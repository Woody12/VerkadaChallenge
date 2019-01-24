//
//  AlertUtil.swift
//  VerkadaChallenge
//
//  Created by Woody Lee on 1/23/19.
//  Copyright © 2019 Woody Lee. All rights reserved.
//

import UIKit

class AlertUtil {
	public static func showDialog(title: String?, message: String?, target: UIViewController) {
		let alertController = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		alertController.addAction(okAction)
		target.present(alertController, animated: true, completion: nil)
	}
}
