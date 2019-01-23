//
//  HomeViewController.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/19/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeViewProtocol {
	
	@IBOutlet weak var camImageView: UIImageView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var cancelSearchView: UIView!
	@IBOutlet weak var gridCollectionView: UICollectionView!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var camInfoLabel: UILabel!
	
	internal var presenter: HomePresenterProtocol? = HomePresenter()
	private var thumbnailViewController: ThumbnailViewController!
	
	private var isShowGrid = false
	private var isReloadCam = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initView()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		if UIDevice.current.orientation.isLandscape {
			print("Landscape")
		} else {
			print("Portrait")
		}
		
		// Reload the grid overlay
		gridCollectionView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		// Connect to ContainerView
		if segue.identifier == EmbedSegue {
			thumbnailViewController = segue.destination as? ThumbnailViewController
		}
	}
	
	@IBAction func searchClick(_ sender: Any) {
		
		if !isShowGrid {
			setupMotionSearch()
		} else {
			showDateTimePicker()
		}
	}
	
	// Public Declaration
	
	public func reloadThumbnail(thumbnailCount: Int) {
		thumbnailViewController.numberOfThumbnails = thumbnailCount
		
		// Load Cam Photo to first photo in the thumbnail if needed
		if isReloadCam {
			displayCamImage(at: 0)
		}
	}
	
	public func displayNoResult() {
		
		DispatchQueue.main.async {
			let alertController = UIAlertController(title: "Motion API Result", message: "No images are found", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			
			alertController.addAction(okAction)
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	public func displayCamImage(at index: Int) {
		
		if presenter?.foundImage(index: index) ?? false {
			
			// Display the Cam View for first image
			if let camImageData = presenter?.retrieveImage(index: index) {
				
				camImageView.image = UIImage(data: camImageData)
				camInfoLabel.text = presenter?.retrieveInfo(index: index)
				isReloadCam = false
			}
		}
	}
	
	// Private Declaration
	private func initView() {
		
		// Setup Presenter and show current date and time with one hour lag
		presenter?.homeView = self
		let yesterday = Date(timeInterval: -24 * DefaultHourLag, since: Date())
		presenter?.search(startTimeDate: yesterday, endTimeDate: Date(timeInterval: DefaultHourLag, since: yesterday))
		
		gridCollectionView.allowsMultipleSelection = true
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clearSearch))
		tapGesture.cancelsTouchesInView = false   // Allow grid to be selected
		cancelSearchView.addGestureRecognizer(tapGesture)
		
		let gridTapGesture = UITapGestureRecognizer(target: self, action: #selector(setupMotionSearch))
		camImageView.addGestureRecognizer(gridTapGesture)
		
		camInfoLabel.text = Date.display(dateStyle: .medium, timeStyle: .medium, date: Date())
	}
	
	private func showDateTimePicker()  {
		
		// Initialize date time picker
		let dateTimePicker = setupDatePicker()
		
		// Add to actionsheetview
		let alertController = UIAlertController(title: "Date and Time Range Selection", message:" " , preferredStyle: .actionSheet)
		
		alertController.view.addSubview(dateTimePicker)
		
		let doneAction = UIAlertAction(title: "Done", style: .cancel) { (action) in
			self.datePickDone(datePicker: dateTimePicker)
		}
		
		//add button to action sheet
		alertController.addAction(doneAction)
		
		let height = NSLayoutConstraint(item: alertController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
		alertController.view.addConstraint(height);
		
		self.present(alertController, animated: true, completion: nil)
		
	}
	
	private func setupDatePicker() -> UIDatePicker {
		
		// Setup date selection from today to last 12 months
		
		let currentDate: Date = Date()
		var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
		calendar.timeZone = TimeZone(identifier: "UTC")!
		
		var components: DateComponents = DateComponents()
		components.calendar = calendar
		components.year = -1 // Back one year
		let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
		
		let dateTimePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 200))
		
		dateTimePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
		dateTimePicker.addTarget(self, action: #selector(dateSelected(datePicker:)), for: .valueChanged)
		dateTimePicker.minimumDate = minDate
		dateTimePicker.maximumDate = Date() // Today Date
		
		return dateTimePicker
	}
	
	private func selectGrid(at cell: UICollectionViewCell?) {
		cell?.contentView.layer.borderWidth = 2.0
		cell?.contentView.layer.borderColor = UIColor.red.cgColor
		cell?.contentView.layer.backgroundColor = UIColor.clear.cgColor
	}
	
	private func deSelectGrid(at cell: UICollectionViewCell?) {
		cell?.contentView.layer.borderWidth = 2.0
		cell?.contentView.layer.borderColor = UIColor.green.cgColor
		cell?.contentView.layer.backgroundColor = UIColor.clear.cgColor
	}
	
	private func showGrid() {
		UIView.animate(withDuration: 0.25) {
			self.gridCollectionView.alpha = 1.0
		}
	}
	
	private func hideGrid() {
		UIView.animate(withDuration: 0.25) {
			self.gridCollectionView.alpha = 0
		}
	}
	
	// Event Handler
	
	@objc
	func clearSearch() {
		
		// Reset Search
		presenter?.clearSearch()
		hideGrid()
		isShowGrid = false
		searchButton.setTitle("Motion Search", for: .normal)
		
		// Clear grid selection
		gridCollectionView.reloadData()
	}
	
	@objc
	func setupMotionSearch() {
		showGrid()
		searchButton.setTitle("Date Range", for: .normal)
		
		// Set Flag
		isShowGrid = true
	}
	
	@objc
	func dateSelected(datePicker: UIDatePicker) {
//		camInfoLabel.text =	Date.display(dateStyle: .medium, timeStyle: .medium, date: datePicker.date)
	}
	
	@objc
	func datePickDone(datePicker: UIDatePicker) {
		dateSelected(datePicker: datePicker)
		presenter?.search(startTimeDate: datePicker.date, endTimeDate: Date(timeInterval: DefaultHourLag, since: datePicker.date))
		clearSearch()
		
		// Set the flag to reload Cam due to new query
		isReloadCam = true
	}
}

extension HomeViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return TotalGrid
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridReuse, for: indexPath)
		deSelectGrid(at: cell)
		return cell
	}
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		// Number of cells
		let collectionViewWidth = collectionView.bounds.width / CGFloat(10)
		let collectionViewHeight = collectionView.bounds.height / CGFloat(10)
		
		return CGSize(width: collectionViewWidth, height: collectionViewHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}

extension HomeViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		// Store selected grid cell
		let gridX = indexPath.row / NumRow
		let gridY = indexPath.row % NumRow
		presenter?.storeGrid(gridX: gridX, gridY: gridY)
		
		let cell = collectionView.cellForItem(at: indexPath)
		selectGrid(at: cell)
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
		// Remove selected grid cell
		let gridX = indexPath.row / NumRow
		let gridY = indexPath.row % NumRow
		presenter?.removeGrid(gridX: gridX, gridY: gridY)
		
		let cell = collectionView.cellForItem(at: indexPath)
		deSelectGrid(at: cell)
	}
}
