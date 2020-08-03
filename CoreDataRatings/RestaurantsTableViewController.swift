//
//  RestaurantsTableViewController.swift
//  CoreDataRatings
//
//  Created by Don Mag on 8/3/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

import UIKit
import CoreData

class RestaurantsTableViewController: UITableViewController {
	
	var restaurants: [NSManagedObject] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(RestaurantCell.self, forCellReuseIdentifier: "cell")
		
		guard let appDelegate =
			UIApplication.shared.delegate as? AppDelegate else {
				return
		}
		
		let managedContext =
			appDelegate.persistentContainer.viewContext
		
		let fetchRequest =
			NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
		
		do {
			restaurants = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could not fetch. \(error), \(error.userInfo)")
		}
		
		// if we don't have any Core Data yet,
		//	create 3 examples
		if restaurants.count == 0 {
			
			for (name, image) in zip(["Bob's Burgers", "The Pizza Joint", "China Dragon"], ["burgers", "pizzas", "chinese"]) {
				
				let entity =
					NSEntityDescription.entity(forEntityName: "Restaurant",
											   in: managedContext)!
				
				let restaurant = NSManagedObject(entity: entity,
												 insertInto: managedContext)
				
				restaurant.setValue(name, forKeyPath: "name")
				restaurant.setValue(image, forKey: "image")
				restaurant.setValue("happy", forKey: "rating")
				
				do {
					try managedContext.save()
					restaurants.append(restaurant)
				} catch let error as NSError {
					print("Could not save. \(error), \(error.userInfo)")
				}
				
			}
			
		}
		
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return restaurants.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantCell
		
		let r = restaurants[indexPath.row]
		
		if let name = r.value(forKey: "name") as? String {
			cell.nameLabel.text = name
		}
		if let image = r.value(forKey: "image") as? String {
			if let img = UIImage(named: image) {
				cell.restaurantImageView.image = img
			}
		}
		if let rating = r.value(forKey: "rating") as? String {
			if let img = UIImage(named: rating) {
				cell.ratingsIconImageView.image = img
			}
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let vc = RestaurantDetailViewController()
		vc.currentRestaurant = restaurants[indexPath.row]
		
		// set the closure to update row when rating is changed
		vc.callbackToTableVC = {
			self.tableView.reloadData()
		}
		
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
}

