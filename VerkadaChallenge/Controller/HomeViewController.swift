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
	@IBOutlet weak var gridCollectionView: UICollectionView!
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var camInfoLabel: UILabel!
	
	private var presenter = HomePresenter()
	
	private var isShowGrid = false
	
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
	
	@IBAction func searchClick(_ sender: Any) {
		
		if !isShowGrid {
			showGrid()
			searchButton.setTitle("Cancel", for: .normal)
		} else {
			hideGrid()
			searchButton.setTitle("Search", for: .normal)
		}
		
		// Toggle Flag
		isShowGrid = !isShowGrid
	}
	
	// Private Declaration
	private func initView() {
		presenter.homeView = self
		presenter.search()
		
		gridCollectionView.allowsMultipleSelection = true
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clearSearch))
		tapGesture.cancelsTouchesInView = false   // Allow grid to be selected
		
		let gridTapGesture = UITapGestureRecognizer(target: self, action: #selector(showGrid))
		camImageView.addGestureRecognizer(gridTapGesture)
		
		camInfoLabel.text = "01/12/2019 02:17am"
	}
	
	private func selectGrid(at cell: UICollectionViewCell?) {
		cell?.contentView.layer.borderWidth = 2.0
		cell?.contentView.layer.borderColor = UIColor.red.cgColor
		cell?.contentView.layer.backgroundColor = UIColor.blue.cgColor
	}
	
	private func deSelectGrid(at cell: UICollectionViewCell?) {
		cell?.contentView.layer.borderWidth = 2.0
		cell?.contentView.layer.borderColor = UIColor.green.cgColor
		cell?.contentView.layer.backgroundColor = UIColor.blue.cgColor
	}
	
	private func hideGrid() {
		UIView.animate(withDuration: 0.25) {
			self.gridCollectionView.alpha = 0
		}
	}
	
	@objc
	func clearSearch() {
		presenter.clearSearch()
		hideGrid()
		view.endEditing(true)
		
	}
	
	@objc
	func showGrid() {
		UIView.animate(withDuration: 0.25) {
			self.gridCollectionView.alpha = 1.0
		}
		
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
		presenter.storeGrid(gridX: gridX, gridY: gridY)
		
		let cell = collectionView.cellForItem(at: indexPath)
		selectGrid(at: cell)
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
		// Remove selected grid cell
		let gridX = indexPath.row / NumRow
		let gridY = indexPath.row % NumRow
		presenter.removeGrid(gridX: gridX, gridY: gridY)
		
		let cell = collectionView.cellForItem(at: indexPath)
		deSelectGrid(at: cell)
	}
}
