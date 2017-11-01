//
//  PersonListViewController.swift
//  Github Viewer
//
//  Created by Sujay Patwardhan on 10/29/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit
import SafariServices
import CoreData

// parent class for following and followers, provides common functionality
class PersonListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: Caching
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: CoreData
    lazy var fetchedResultsController: NSFetchedResultsController<Person> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "userName", ascending: true)
        ]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to launch NSFetchedResultsController.performFetch()")
        }
    }
    // handles tapping on user to show profile
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileViewController = segue.destination as? ProfileViewController,
            let indexPath = sender as? IndexPath {
            profileViewController.username = fetchedResultsController.object(at: indexPath).userName ?? ""
        }
    }
    
    // MARK: UITableViewDatasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count
    }
    // loads profile image for each profile in the table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let person = fetchedResultsController.object(at: indexPath)
        
        
        if let imgURL = person.imgURL {
            let nsImgURL = imgURL as NSString
            
            if let image = imageCache.object(forKey: nsImgURL) {
                cell.imageView?.image = image
                
            } else if let url = URL(string: imgURL),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                cell.imageView?.image = image
                imageCache.setObject(image, forKey: nsImgURL)
                
            }
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "profile")
            
        }
        cell.textLabel?.text = person.userName
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count > 0 ? 1 : 0
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "showProfileView", sender: indexPath)
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            tableView.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            guard let updateIndexPath = indexPath else { return }
            tableView.reloadRows(at: [updateIndexPath], with: .fade)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [toIndexPath],   with: .fade)
            tableView.deleteRows(at: [fromIndexPath], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

