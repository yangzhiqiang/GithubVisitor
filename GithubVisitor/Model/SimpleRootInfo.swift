//
//  SimpleRootInfo.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/15.
//

import Foundation

/// Simple version model, only store a key-value.
/// User could use it keys get value directly. and visibiliy and order could be controled by `displayKeys`.
struct SimpleRootInfo {
    /// Define the order and visibility of a key item
    static var displayKeys: [String] = [
          "current_user_url",
          "current_user_authorizations_html_url",
          "authorizations_url",
          "code_search_url",
          "commit_search_url",
          "emails_url",
          "emojis_url",
          "events_url",
          "feeds_url",
          "followers_url",
          "following_url",
          "gists_url",
          "hub_url",
          "issue_search_url",
          "issues_url",
          "keys_url",
          "label_search_url",
          "notifications_url",
          "organization_url",
          "organization_repositories_url",
          "organization_teams_url",
          "public_gists_url",
          "rate_limit_url",
          "repository_url",
          "repository_search_url",
          "current_user_repositories_url",
          "starred_url",
          "starred_gists_url",
          "user_url",
          "user_organizations_url",
          "user_repositories_url",
          "user_search_url"
    ]
    
    /// store the key-value
    private var record: [String: String] = [:]
    
    subscript(key: String) -> String? {
        return record[key]
    }
    
    init?(cache: CacheRecord) {
        guard cache.errorCode == 0 else {
            return nil
        }
        
        if let data = cache.rawString.data(using: .utf8),
           let record = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : String] {
            self.record = record
        }
    }
}

