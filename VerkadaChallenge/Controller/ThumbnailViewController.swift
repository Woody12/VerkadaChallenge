//
//  ThumbnailViewController.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/20/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class ThumbnailViewController: UIViewController {
	
	@IBOutlet weak var thumbnailCollectionView: UICollectionView!
	
	public var numberOfThumbnails: Int = 0 {
		didSet {
			thumbnailCollectionView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
}

extension ThumbnailViewController {
	
}

extension ThumbnailViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfThumbnails
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailReuse, for: indexPath)
		
		if let parentController = parent as? HomeViewController {
			cell.contentView.backgroundColor = parentController.presenter?.retrieveImage(index: indexPath.row)
		}
		
		return cell
	}
}

extension ThumbnailViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		// Number of cells
		let collectionViewWidth = collectionView.bounds.width / CGFloat(5)
		let collectionViewHeight = collectionView.bounds.height / CGFloat(5)
		
		return CGSize(width: collectionViewWidth, height: collectionViewHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
}

extension ThumbnailViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
//		// Store selected grid cell
//		let gridX = indexPath.row / NumRow
//		let gridY = indexPath.row % NumRow
//		presenter.storeGrid(gridX: gridX, gridY: gridY)
//
//		let cell = collectionView.cellForItem(at: indexPath)
//		selectGrid(at: cell)
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
//		// Remove selected grid cell
//		let gridX = indexPath.row / NumRow
//		let gridY = indexPath.row % NumRow
//		presenter.removeGrid(gridX: gridX, gridY: gridY)
//
//		let cell = collectionView.cellForItem(at: indexPath)
//		deSelectGrid(at: cell)
	}
}
