//
//  GithubService.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/29/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import Foundation
import APIManager

// this class abstracts out all API requests using the APIManager pod.
class GithubService: APIService {
    static var baseURL: String = "https://api.github.com"

    static var headers: HTTPHeaders?

    static func validate(json: JSON) -> JSONValidationResult {
        return .success
    }

    open class func getUser(byName name: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/users/\(name)", params: nil, body: nil, method: .GET)
    }

    open class func getRepos(byName name: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/users/\(name)/repos", params: nil, body: nil, method: .GET)
    }

    open class func getFollowing(byName name: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/users/\(name)/following", params: nil, body: nil, method: .GET)
    }

    open class func getFollowers(byName name: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/users/\(name)/followers", params: nil, body: nil, method: .GET)
    }
    
    open class func doesUserFollow(byUsername user: String, targetUsername target: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/users/\(user)/following/\(target)", params: nil, body: nil, method: .GET)
    }
    
    
    
    // Below requires auth
    
    open class func followUser(target: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/user/following/\(target)", params: nil, body: nil, method: .PUT)
    }
    
    open class func unfollowUser(target: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/user/following/\(target)", params: nil, body: nil, method: .DELETE)
    }
    
    open class func doesUserHaveStarred(byUsername user: String, repoName target: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/user/starred/\(user)/\(target)", params: nil, body: nil, method: .GET)
    }
    
    open class func starRepo(byUsername user: String, repoName target: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/user/starred/\(user)/\(target)", params: nil, body: nil, method: .PUT)
    }
    
    open class func unstarRepo(byUsername user: String, repoName target: String) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/user/starred/\(user)/\(target)", params: nil, body: nil, method: .DELETE)
    }
    
    open class func getNotifications() -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/notifications", params: nil, body: nil, method: .GET)
    }
    
    open class func searchForRepo(params: [String: String]) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/search/repositories", params: params, body: nil, method: .GET)
    }
    
    open class func searchForUser(params: [String: String]) -> APIRequest<GithubService> {
        return APIRequest<GithubService>(endpoint: "/search/users", params: params, body: nil, method: .GET)
    }

}
