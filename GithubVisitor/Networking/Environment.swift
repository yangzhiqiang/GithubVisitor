//
//  Environment.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/14.
//

import Foundation

/**
    This enumeration define the environement for Networking

    *Values*
 
    `PROD` for production environment when you release this app

    `TEST` for test environment when you debug or test this app

 */
enum Environment {
    case PROD
    case TEST
    
    /// Base URL in current Environment
    var baseURL: String {
        switch self {
        case .PROD:
            return "https://api.github.com"
        case .TEST:
            return "https://api.github.com"
        }
    }
}

// indicate current environment of Networking
var ENV = Environment.PROD
