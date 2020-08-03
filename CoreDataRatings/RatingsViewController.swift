//
//  RatingsViewController.swift
//  CoreDataRatings
//
//  Created by Don Mag on 8/3/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

import UIKit

class RatingsViewController: UIViewController {
	
	// set by calling controller
	var bgImage: String?
	
	weak var ratingDelegate: RatingsPresentationDelegate?
	
	let stackMoji = UIStackView()
	let crossBtn = UIButton()
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		stackMoji.arrangedSubviews.forEach { b in
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
				b.transform = .identity
			}, completion: nil)
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if true {
			
			let ratings: [String] = ["cool", "happy","love", "sad", "angry"]
			
			let animationBlur = UIBlurEffect(style: .dark)
			let visualBlurView = UIVisualEffectView(effect: animationBlur)
			
			let bkgImageView = UIImageView()
			
			// assign its .mage property
			if let s = bgImage, let img = UIImage(named: s) {
				bkgImageView.image = img
			}
			
			
			// add elements to self
			view.addSubview(bkgImageView)
			view.addSubview(visualBlurView)
			
			bkgImageView.translatesAutoresizingMaskIntoConstraints = false
			visualBlurView.translatesAutoresizingMaskIntoConstraints = false
			bkgImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
			bkgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
			bkgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
			bkgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
			
			// constrain visualBlurView to all 4 sides
			visualBlurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
			visualBlurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
			visualBlurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
			visualBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
			
			bkgImageView.contentMode = .scaleAspectFill
			
			stackMoji.translatesAutoresizingMaskIntoConstraints = false
			
			stackMoji.axis = .vertical
			stackMoji.spacing = 5
			stackMoji.distribution = .fillEqually
			stackMoji.alignment = .leading
			
			// start with system font
			var font = UIFont.systemFont(ofSize: 30, weight: .bold)
			
			// buttons use "Rubik-Medium" if available
			if let f = UIFont(name: "Rubik-Medium", size: 30) {
				font = f
			}
			let fontM = UIFontMetrics(forTextStyle: .body)
			
			ratings.forEach { (btn) in
				let b = UIButton()
				b.setTitle(btn, for: .normal)
				b.titleLabel?.font = fontM.scaledFont(for: font)
				b.setImage(UIImage(named: btn), for: .normal)
				b.imageView?.contentMode = .scaleAspectFit
				stackMoji.addArrangedSubview(b)
				
				//btn animation
				let sizeAnimation = CGAffineTransform(scaleX: 5, y: 5)
				let positionAnimation = CGAffineTransform(translationX: 1000, y: 0)
				let combinedAninaton = sizeAnimation.concatenating(positionAnimation)
				b.transform = combinedAninaton
				b.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
			}
			
			view.addSubview(stackMoji)
			
			stackMoji.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
			stackMoji.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
			stackMoji.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
			
			if let img = UIImage(named: "cross") {
				crossBtn.setImage(img, for: [])
			} else {
				crossBtn.setTitle("X", for: [])
				crossBtn.setTitleColor(.white, for: .normal)
				crossBtn.setTitleColor(.gray, for: .highlighted)
				crossBtn.titleLabel?.font = UIFont.systemFont(ofSize: 44, weight: .bold)
			}
			
			view.addSubview(crossBtn)
			
			crossBtn.translatesAutoresizingMaskIntoConstraints = false
			crossBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
			crossBtn.bottomAnchor.constraint(equalTo: stackMoji.topAnchor, constant: -16).isActive = true
			
			crossBtn.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
			
		}
		
	}
	
	@objc func ratingButtonTapped(_ sender: UIButton) {
		
		// if crossButton is tapped, and has an image instead of title of "X"
		//	set returnRating to ""
		var returnRating = sender.titleLabel?.text ?? ""
		
		// if crossButton is tapped, and has a title of "X"
		//	set returnRating to ""
		if returnRating == "X" {
			returnRating = ""
		}
		
		ratingDelegate?.defineTheRatings(returnRating)

		
	}
	
}
