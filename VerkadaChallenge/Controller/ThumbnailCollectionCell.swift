//
//  ThumbnailCollectionCell.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/23/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class ThumbnailCollectionCell: UICollectionViewCell {
	
	public var imageView: UIImageView
	public var infoLabel: UILabel
	
	override init(frame: CGRect) {
	
		// Initialize objects before super init
		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2/3))
		infoLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.size.height, width: frame.size.width, height: frame.size.height*1/3))
		
		super.init(frame: frame)
		
		imageView.contentMode = .scaleAspectFit
		contentView.addSubview(imageView)
		
		infoLabel.font = UIFont(name: "Helvetica", size: CGFloat(10.0))
		infoLabel.numberOfLines = 0
		infoLabel.lineBreakMode = .byWordWrapping
		contentView.addSubview(infoLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
