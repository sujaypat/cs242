//
//  NotificationsViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 11/1/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import Foundation
import APIManager
import CoreData
import SafariServices


class NotificationsViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: Caching
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: CoreData
    lazy var fetchedResultsController: NSFetchedResultsController<Notification> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Notification> = Notification.fetchRequest()
        
//        // Configure Fetch Request
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: true)
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
    // handles tapping on notification to show thread
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        let view = SFSafariViewController(url: URL(string: fetchedResultsController.object(at: indexPath).url! + "?access_token=" + (UserModel.shared.key ?? ""))!)
//        self.present(view, animated: true, completion: nil)
//
    }
    
    // MARK: UITableViewDatasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count
    }
    // loads profile image for each profile in the table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let notif = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = notif.title
        cell.detailTextLabel?.text = notif.repo
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
//        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return 0 }
//        return fetchedObjects.count > 0 ? 1 : 0
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
