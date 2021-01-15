//
//  NotificationKey.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/15.
//

import Foundation

/// define some notification name using in project
extension Notification.Name {
    /// Cache was inserted new item
    public static let githubCacheChanged = Notification.Name("githubCacheChanged")
}
