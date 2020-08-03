//
//  RestaurantDetailViewController.swift
//  CoreDataRatings
//
//  Created by Don Mag on 8/3/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

import UIKit
import CoreData

protocol RatingsPresentationDelegate: class {
	func defineTheRatings(_ ratings: String)
}

class RestaurantDetailViewController: UIViewController, RatingsPresentationDelegate {
	
	// set by calling controller
	var currentRestaurant: NSManagedObject!
	
	var callbackToTableVC: (() ->())?
	
	let restaurantImageView = UIImageView()
	let nameLabel = UILabel()
	let ratingsIconImageView = UIImageView()
	
	let pushButton = UIButton()
	let presentButton = UIButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		if currentRestaurant == nil {
			fatalError("currentRestaurant was not set!")
		}
		
		restaurantImageView.contentMode = .scaleAspectFill
		ratingsIconImageView.contentMode = .scaleAspectFit
		
		pushButton.setTitle("Push to Ratings", for: [])
		presentButton.setTitle("Present Ratings", for: [])
		
		[pushButton, presentButton].forEach { b in
			b.setTitleColor(.white, for: .normal)
			b.setTitleColor(.gray, for: .highlighted)
			b.backgroundColor = .red
			b.widthAnchor.constraint(equalToConstant: 200).isActive = true
			b.addTarget(self, action: #selector(self.gotoRatings(_:)), for: .touchUpInside)
		}
		
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		stack.alignment = .center
		stack.spacing = 8
		
		stack.addArrangedSubview(restaurantImageView)
		stack.addArrangedSubview(nameLabel)
		stack.addArrangedSubview(ratingsIconImageView)
		stack.addArrangedSubview(pushButton)
		stack.addArrangedSubview(presentButton)
		
		view.addSubview(stack)
		
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			stack.topAnchor.constraint(equalTo: g.topAnchor),
			stack.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			
			// restaurant images are 1.25:1 ratio
			restaurantImageView.widthAnchor.constraint(equalTo: stack.widthAnchor),
			restaurantImageView.heightAnchor.constraint(equalTo: restaurantImageView.widthAnchor, multiplier: 1.0 / 1.25),
			
			// rating (emoji) images
			ratingsIconImageView.heightAnchor.constraint(equalToConstant: 60.0),
			ratingsIconImageView.widthAnchor.constraint(equalTo: ratingsIconImageView.heightAnchor),
			
		])
		
		if let name = currentRestaurant.value(forKey: "name") as? String {
			nameLabel.text = name
		}
		if let image = currentRestaurant.value(forKey: "image") as? String {
			if let img = UIImage(named: image) {
				restaurantImageView.image = img
			}
		}
		if let rating = currentRestaurant.value(forKey: "rating") as? String {
			if let img = UIImage(named: rating) {
				ratingsIconImageView.image = img
			}
		}
		
		// prepare for animation
		let scaleTransform = CGAffineTransform(scaleX: 5, y: 5)
		ratingsIconImageView.transform = scaleTransform
		ratingsIconImageView.alpha = 0
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if ratingsIconImageView.transform != .identity {
			
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
				self.ratingsIconImageView.alpha = 1
				self.ratingsIconImageView.transform = .identity
			}, completion: nil)
			
		}
		
	}
	
	@objc func gotoRatings(_ sender: UIButton) -> Void {
		
		guard let title = sender.currentTitle else {
			return
		}
		
		let vc = RatingsViewController()
		
		// set the RatingsPresentationDelegate
		vc.ratingDelegate = self
		
		if let image = currentRestaurant.value(forKey: "image") as? String {
			vc.bgImage = image
		}
		
		if title == "Push to Ratings" {
			self.navigationController?.pushViewController(vc, animated: true)
		} else {
			vc.modalPresentationStyle = .fullScreen
			self.present(vc, animated: true, completion: nil)
		}
		
	}
	
	func defineTheRatings(_ ratings: String) {
		
		// if the "X" button was tapped, we get "" (no title)
		//	so only change data if it's NOT ""
		
		if ratings != "" {
			// update currentRestaurant object
			self.currentRestaurant.setValue(ratings, forKey: "rating")
			// update data store
			if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
				appDelegate.saveContext()
			}
			// update detail view's Icon Image
			if let img = UIImage(named: ratings) {
				ratingsIconImageView.image = img
			}
			// tell the table view controller about the updated rating
			callbackToTableVC?()
		}
		
		// dismiss ratings view controller
		//	if it was presented
		// otherwise, pop it off the navigation controller stack
		if self.presentedViewController != nil {
			self.dismiss(animated: true, completion: nil)
		} else {
			self.navigationController?.popViewController(animated: true)
		}
		
	}
	
}

