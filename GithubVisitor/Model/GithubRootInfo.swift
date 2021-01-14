//
//  GithubRootInfo.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/14.
//

import Foundation
import HandyJSON

/**
    This class parse the JSON and converts it into this object
 */
class GithubRootInfo: HandyJSON {
    var currentUserUrl: String = ""
    var currentUserAuthorizationsHtmlUrl: String = ""
    var authorizationsUrl: String = ""
    var codeSearchUrl: String = ""
    var commitSearchUrl: String = ""
    var emailsUrl: String = ""
    var emojisUrl: String = ""
    var eventsUrl: String = ""
    var feedsUrl: String = ""
    var followersUrl: String = ""
    var followingUrl: String = ""
    var gistsUrl: String = ""
    var hubUrl: String = ""
    var issueSearchUrl: String = ""
    var issuesUrl: String = ""
    var keysUrl: String = ""
    var labelSearchUrl: String = ""
    var notificationsUrl: String = ""
    var organizationUrl: String = ""
    var organizationRepositoriesUrl: String = ""
    var organizationTeamsUrl: String = ""
    var publicGistsUrl: String = ""
    var rateLimitUrl: String = ""
    var repositoryUrl: String = ""
    var repositorySearchUrl: String = ""
    var currentUserRepositoriesUrl: String = ""
    var starredUrl: String = ""
    var starredGistsUrl: String = ""
    var userUrl: String = ""
    var userOrganizationsUrl: String = ""
    var userRepositoriesUrl: String = ""
    var userSearchUrl: String = ""

    /**
        This function is HandJSON method.
        Because keys of returned JSON does not conform to the Swift Naming Specification,
        we use it to mapping some field in json to corresponding' property in object
     */
    func mapping(mapper: HelpingMapper) {
        
        mapper <<<
            self.currentUserUrl <-- "current_user_url"
        mapper <<<
            self.currentUserAuthorizationsHtmlUrl <-- "current_user_authorizations_html_url"
        mapper <<<
            self.authorizationsUrl <-- "authorizations_url"
        mapper <<<
            self.codeSearchUrl <-- "code_search_url"
        mapper <<<
            self.commitSearchUrl <-- "commit_search_url"
        mapper <<<
            self.emailsUrl <-- "emails_url"
        mapper <<<
            self.emojisUrl <-- "emojis_url"
        mapper <<<
            self.eventsUrl <-- "events_url"
        mapper <<<
            self.feedsUrl <-- "feeds_url"
        mapper <<<
            self.followersUrl <-- "followers_url"
        mapper <<<
            self.followingUrl <-- "following_url"
        mapper <<<
            self.gistsUrl <-- "gists_url"
        mapper <<<
            self.hubUrl <-- "hub_url"
        mapper <<<
            self.issueSearchUrl <-- "issue_search_url"
        mapper <<<
            self.issuesUrl <-- "issues_url"
        mapper <<<
            self.keysUrl <-- "keys_url"
        mapper <<<
            self.labelSearchUrl <-- "label_search_url"
        mapper <<<
            self.notificationsUrl <-- "notifications_url"
        mapper <<<
            self.organizationUrl <-- "organization_url"
        mapper <<<
            self.organizationRepositoriesUrl <-- "organization_repositories_url"
        mapper <<<
            self.organizationTeamsUrl <-- "organization_teams_url"
        mapper <<<
            self.publicGistsUrl <-- "public_gists_url"
        mapper <<<
            self.rateLimitUrl <-- "rate_limit_url"
        mapper <<<
            self.repositoryUrl <-- "repository_url"
        mapper <<<
            self.repositorySearchUrl <-- "repository_search_url"
        mapper <<<
            self.currentUserRepositoriesUrl <-- "current_user_repositories_url"
        mapper <<<
            self.starredUrl <-- "starred_url"
        mapper <<<
            self.starredGistsUrl <-- "starred_gists_url"
        mapper <<<
            self.userUrl <-- "user_url"
        mapper <<<
            self.userOrganizationsUrl <-- "user_organizations_url"
        mapper <<<
            self.userRepositoriesUrl <-- "user_repositories_url"
        mapper <<<
            self.userSearchUrl <-- "user_search_url"
    }
    
    required init() {}
}


