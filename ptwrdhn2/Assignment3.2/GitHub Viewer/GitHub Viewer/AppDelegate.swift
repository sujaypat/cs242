//
//  AppDelegate.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit
import CoreData
import OAuthSwift
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var oauthswift: OAuth2Swift?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.host == "asdf") {
            OAuthSwift.handle(url: url)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        CoreDataManager.shared.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let _ = CoreDataManager.shared

        self.oauthswift = OAuth2Swift(
            consumerKey:    "cc8b40bc12358262d119",
            consumerSecret: "2f8cc0d76aee2fed36e88293263c1c1e19021ba2",
            authorizeUrl:   "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType:   "token"
        )
        let _ = self.oauthswift!.authorize(
            withCallbackURL: "github-viewer://asdf",
            scope: "user,public_repo,notifications",
            state: "authorized",
            success: { credential, response, parameters in
                UserModel.shared.key = credential.oauthToken
                print(credential.oauthToken)
                self.authorizedRequests()
        },
            failure: { error in
                print(error, error.localizedDescription)
        }
        )
        
    }
    
    func authorizedRequests() {
        GithubService.getFollowers(byName: USER)
        .onSuccess{ (json) in
            
            DispatchQueue.main.async {
                
                for item in json.arrayValue {
                    guard let intId = item["id"].int else { continue }
                    let id = Int64(intId)
                    
                    let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
                    fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                    guard let result = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest) else { continue }
                    
                    var person: Person
                    switch result.count {
                    case 0:
                        person = Person(context: CoreDataManager.shared.persistentContainer.viewContext)
                        person.following = false
                    case 1:
                        person = result[0]
                    default:
                        fatalError("Internal error")
                    }
                    
                    person.id       = id
                    person.follower = true
                    person.imgURL   = item["avatar_url"].stringValue
                    person.url      = item["html_url"].stringValue
                    person.userName = item["login"].stringValue
                }
            }
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: nil)
        
        
        GithubService.getFollowing(byName: USER)
        .onSuccess{ (json) in
            
            DispatchQueue.main.async {
                
                for item in json.arrayValue {
                    guard let intId = item["id"].int else { continue }
                    let id = Int64(intId)

                    let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
                    fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                    guard let result = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest) else { continue }
                    
                    var person: Person
                    switch result.count {
                    case 0:
                        person = Person(context: CoreDataManager.shared.persistentContainer.viewContext)
                        person.follower = false
                    case 1:
                        person = result[0]
                    default:
                        fatalError("Internal error")
                    }
                    
                    person.id        = id
                    person.following = true
                    person.imgURL    = item["avatar_url"].stringValue
                    person.url       = item["html_url"].stringValue
                    person.userName  = item["login"].stringValue
                }
            }
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: nil)
        
        GithubService.getRepos(byName: USER)
        .onSuccess { (json) in
            
            DispatchQueue.main.async() {
            
                for item in json.arrayValue {
                    guard let name = item["name"].string else { continue }
                    
                    let fetchRequest = NSFetchRequest<Repo>(entityName: "Repo")
                    fetchRequest.predicate = NSPredicate(format: "name == %@", name)
                    guard let result = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest) else { continue }
                    
                    var repo: Repo
                    switch result.count {
                    case 0:
                        repo = Repo(context: CoreDataManager.shared.persistentContainer.viewContext)
                    case 1:
                        repo = result[0]
                    default:
                        fatalError("Internal error")
                    }
                    
                    repo.name     = name
                    repo.userName = item["owner"]["login"].stringValue
                    repo.desc     = item["description"].string ?? "No description provided"
                    repo.url      = item["html_url"].stringValue
                    repo.numStars = Int64(item["stargazers_count"].int!)
                    repo.views    = NSMutableArray()
                    repo.views!.removeAllObjects()
                    
                    GithubService.getRepoCommits(byAuthor: item["owner"]["login"].stringValue, byName: name)
                    .onSuccess { json in
                        guard let json = json.array else { return }
                        for item in json {
                            repo.views!.add(item["total"].intValue)
                        }
                    }
                    .onFailure { reason in
                        print(reason)
                    }
                    .perform(withAuthorization: UserModel.shared)
                    
                }
            }
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: UserModel.shared)
        
        GithubService.getNotifications()
        .onSuccess { (json) in
            
            DispatchQueue.main.async() {

                for item in json.arrayValue {
                    
                    guard let intId = item["id"].int else { continue }
                    let id = Int64(intId)

                    let fetchRequest = NSFetchRequest<Notification>(entityName: "Notification")
                    fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                    guard let result = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest) else { continue }
                    
                    var notif: Notification
                    switch result.count {
                    case 0:
                        notif = Notification(context: CoreDataManager.shared.persistentContainer.viewContext)
                    case 1:
                        notif = result[0]
                    default:
                        fatalError("Internal error")
                    }
                    notif.id       = id
                    notif.repo     = item["repository"]["full_name"].stringValue
                    notif.title    = item["subject"]["title"].stringValue
                }
            }
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: UserModel.shared)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataManager.shared.saveContext()
    }
}

