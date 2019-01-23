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
		
		// Retrieve Image
		if let parentController = parent as? HomeViewController {
			if let imageData = parentController.presenter?.retrieveImage(index: indexPath.row) {
				
				// Display image
				let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
				let camImage = UIImage(data: imageData)
				imageView.image = camImage
				imageView.contentMode = .scaleAspectFit
				cell.contentView.addSubview(imageView)
				
				let infoLabel = UILabel(frame: CGRect(x: 20, y: 55, width: 100, height: 50))
				infoLabel.font = UIFont(name: "Helvetica", size: CGFloat(12.0))
				infoLabel.numberOfLines = 3
				infoLabel.lineBreakMode = .byWordWrapping
				infoLabel.text = parentController.presenter?.retrieveInfo(index: indexPath.row)
				cell.contentView.addSubview(infoLabel)
				
				// Display the Cam View for first image
				if indexPath.row == 0 {
					parentController.displayCamImage(camImage: camImage)
				}
			}
		}
		
		return cell
	}
}

extension ThumbnailViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		// Number of cells
		let collectionViewWidth = collectionView.bounds.width / CGFloat(5)
		let collectionViewHeight = CGFloat(120)
		
		return CGSize(width: collectionViewWidth, height: collectionViewHeight)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
}

extension ThumbnailViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		// Show Cam Image
		if let parentController = parent as? HomeViewController,
			let imageData = parentController.presenter?.retrieveImage(index: indexPath.row) {
				let camImage = UIImage(data: imageData)
				parentController.displayCamImage(camImage: camImage)
		}
	}
}
