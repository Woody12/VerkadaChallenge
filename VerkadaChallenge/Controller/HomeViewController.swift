//
//  HomeViewController.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/19/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
	
	
	@IBOutlet weak var camImageView: UIImageView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var gridCollectionView: UICollectionView!
	
	private var presenter = HomePresenter()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initView()
		
	}
	
	
	// Private Declaration
	private func initView() {
		presenter.homeView = self
		presenter.search()
		
		gridCollectionView.alpha = 0.3
		gridCollectionView.delegate = self
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clearSearch))
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc
	func clearSearch() {
		presenter.clearSearch()
		view.endEditing(true)
	}
}

extension HomeViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return TotalGrid
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridReuse, for: indexPath)
		cell.contentView.layer.borderWidth = 2.0
		cell.contentView.layer.borderColor = UIColor.red.cgColor
		cell.contentView.layer.backgroundColor = UIColor.blue.cgColor
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
		
		print("index row is \(indexPath.row)")
		
		let gridX = indexPath.row / NumRow
		let gridY = indexPath.row % NumRow
		presenter.storeGrid(gridX: gridX, gridY: gridY)
		
	}
}
