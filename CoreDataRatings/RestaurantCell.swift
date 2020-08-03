//
//  RestaurantCell.swift
//  CoreDataRatings
//
//  Created by Don Mag on 8/3/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
	
	let restaurantImageView = UIImageView()
	let nameLabel = UILabel()
	let ratingsIconImageView = UIImageView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .horizontal
		stack.alignment = .center
		stack.spacing = 8
		
		stack.addArrangedSubview(restaurantImageView)
		stack.addArrangedSubview(nameLabel)
		stack.addArrangedSubview(ratingsIconImageView)
		
		contentView.addSubview(stack)
		
		let g = contentView.layoutMarginsGuide
		
		NSLayoutConstraint.activate([
			
			stack.topAnchor.constraint(equalTo: g.topAnchor),
			stack.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			stack.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			stack.bottomAnchor.constraint(equalTo: g.bottomAnchor),
			
			// restaurant images are 1.25:1 ratio
			restaurantImageView.heightAnchor.constraint(equalToConstant: 60.0),
			restaurantImageView.widthAnchor.constraint(equalTo: restaurantImageView.heightAnchor, multiplier: 1.25),
			
			// rating (emoji) images
			ratingsIconImageView.heightAnchor.constraint(equalToConstant: 60.0),
			ratingsIconImageView.widthAnchor.constraint(equalTo: ratingsIconImageView.heightAnchor),
			
		])
		
		restaurantImageView.contentMode = .scaleAspectFill
		ratingsIconImageView.contentMode = .scaleAspectFit
		
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

