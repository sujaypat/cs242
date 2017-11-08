//
//  GitHub ViewerTests.swift
//  GitHub ViewerTests
//
//  Created by Sujay Patwardhan on 11/7/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import XCTest
import OAuthSwift
import SwiftyJSON


class GitHub_ViewerTests: XCTestCase {
    
    var oauthswift: OAuth2Swift?
    var cred: String?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
                self.cred = credential.oauthToken
//                self.authorizedRequests()
        },
            failure: { error in
                print(error, error.localizedDescription)
        }
        )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetProfile() {
        GithubService.getUser(byName: "sujaypat")
        .onSuccess { (json) in
            XCTAssert("sujaypat" == json["login"].stringValue)
            XCTAssert(json["name"].string != nil)
        }
        .perform(withAuthorization: nil)
    }
    
    func testHasRepos() {
        GithubService.getRepos(byName: "sujaypat")
        .onSuccess { (json) in
            let json = json.arrayValue
            XCTAssert(json.count > 0)
        }
        .perform(withAuthorization: nil)
    }
    
    func testHasFollowersAndFollowing() {
        GithubService.getFollowers(byName: "sujaypat")
        .onSuccess { (json) in
            print(json)
            let json = json.arrayValue
            XCTAssert(json.count == 10)
        }
        .perform(withAuthorization: nil)
        
        GithubService.getFollowing(byName: "sujaypat")
        .onSuccess { (json) in
            print(json)
            let json = json.arrayValue
            XCTAssert(json.count == 8)
        }
        .perform(withAuthorization: nil)
    }
    
    
}

