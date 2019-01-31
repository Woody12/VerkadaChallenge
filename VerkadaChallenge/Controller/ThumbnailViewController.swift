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
		
		// Register custom cell
		thumbnailCollectionView.register(ThumbnailCollectionCell.self, forCellWithReuseIdentifier: ThumbnailReuse)
	}
	
}

extension ThumbnailViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfThumbnails
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailReuse, for: indexPath) as! ThumbnailCollectionCell
		
		// Retrieve Image
		if let parentController = parent as? HomeViewController {
			if let imageData = parentController.presenter?.retrieveImage(index: indexPath.row) {
				
				// Display image and info
				let camImage = imageData
				let camInfo = parentController.presenter?.retrieveInfo(index: indexPath.row)
				cell.imageView.image = camImage
				cell.infoLabel.text = camInfo
			}
		}
		
		return cell
	}
}

extension ThumbnailViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		// Number of cells
		let collectionViewWidth = collectionView.bounds.width / CGFloat(5)
		let collectionViewHeight = CGFloat(100)
		
		return CGSize(width: collectionViewWidth, height: collectionViewHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
}

extension ThumbnailViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		// Show Cam Info
		if let parentController = parent as? HomeViewController {
			parentController.displayCamImage(at: indexPath.row)
		}
	}
}
