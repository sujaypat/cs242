//
//  UserModel.swift
//  Github Viewer
//
//  Created by Sujay Patwardhan on 10/29/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import Foundation
import APIManager

class UserModel: APIAuthorization {
    
    static let shared = UserModel()
    private init() { }
    
    var key: String?
    
    func embedInto<Service : APIService>(request: APIRequest<Service>) -> (HTTPParameters?, JSON?) {
        var params = request.params ?? [:]
        params["access_token"] = key
        return (params, request.body)
    }
}
