//
//  GithubVisitorTests.swift
//  GithubVisitorTests
//
//  Created by David Yang on 2021/1/14.
//

import XCTest
@testable import GithubVisitor

class GithubVisitorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class GitbubNetworkTests: XCTestCase {
    func testLoad() throws {
        let expectNormal = expectation(description: "Request should OK")
        GithubNetworkOperation.shared.load(path: "/") { (error, dict) in
            XCTAssertTrue(error == nil)
            XCTAssertTrue(dict != nil)
            
            expectNormal.fulfill()
        }
        
        let expectNotexist = expectation(description: "Request should fail")
        GithubNetworkOperation.shared.load(path: "/notexist") { (error, dict) in
            XCTAssertTrue(error != nil)
            XCTAssertTrue(dict == nil)
            
            expectNotexist.fulfill()
        }

        self.wait(for: [expectNormal, expectNotexist, ], timeout: 10)
    }
    
    func testEndpoit() throws {
        let expectNormal = expectation(description: "Request should OK")
        
        GithubNetworkOperation.shared.visitEndpoint() { (error, dict) in
            XCTAssertTrue(error == nil)
            XCTAssertTrue(dict != nil)
            
            XCTAssertTrue(dict?["current_user_url"] != nil)
            XCTAssertTrue(dict?["current_user_url"] as? String != nil)

            expectNormal.fulfill()
        }
        
        wait(for: [expectNormal], timeout: 10)
    }
}

class GitbubRootInfoTests: XCTestCase {
    private var dict: [String : Any] = [:]

    override func setUpWithError() throws {
        let rawStr =
"""
        {
          "current_user_url": "https://api.github.com/user",
          "current_user_authorizations_html_url": "https://github.com/settings/connections/applications{/client_id}",
          "authorizations_url": "https://api.github.com/authorizations",
          "code_search_url": "https://api.github.com/search/code?q={query}{&page,per_page,sort,order}",
          "commit_search_url": "https://api.github.com/search/commits?q={query}{&page,per_page,sort,order}",
          "emails_url": "https://api.github.com/user/emails",
          "emojis_url": "https://api.github.com/emojis",
          "events_url": "https://api.github.com/events",
          "feeds_url": "https://api.github.com/feeds",
          "followers_url": "https://api.github.com/user/followers",
          "following_url": "https://api.github.com/user/following{/target}",
          "gists_url": "https://api.github.com/gists{/gist_id}",
          "hub_url": "https://api.github.com/hub",
          "issue_search_url": "https://api.github.com/search/issues?q={query}{&page,per_page,sort,order}",
          "issues_url": "https://api.github.com/issues",
          "keys_url": "https://api.github.com/user/keys",
          "label_search_url": "https://api.github.com/search/labels?q={query}&repository_id={repository_id}{&page,per_page}",
          "notifications_url": "https://api.github.com/notifications",
          "organization_url": "https://api.github.com/orgs/{org}",
          "organization_repositories_url": "https://api.github.com/orgs/{org}/repos{?type,page,per_page,sort}",
          "organization_teams_url": "https://api.github.com/orgs/{org}/teams",
          "public_gists_url": "https://api.github.com/gists/public",
          "rate_limit_url": "https://api.github.com/rate_limit",
          "repository_url": "https://api.github.com/repos/{owner}/{repo}",
          "repository_search_url": "https://api.github.com/search/repositories?q={query}{&page,per_page,sort,order}",
          "current_user_repositories_url": "https://api.github.com/user/repos{?type,page,per_page,sort}",
          "starred_url": "https://api.github.com/user/starred{/owner}{/repo}",
          "starred_gists_url": "https://api.github.com/gists/starred",
          "user_url": "https://api.github.com/users/{user}",
          "user_organizations_url": "https://api.github.com/user/orgs",
          "user_repositories_url": "https://api.github.com/users/{user}/repos{?type,page,per_page,sort}",
          "user_search_url": "https://api.github.com/search/users?q={query}{&page,per_page,sort,order}"
        }
"""
        
        if let dict = try? JSONSerialization.jsonObject(with: rawStr.data(using: .utf8)!, options: []) as? [String : Any] {
            self.dict = dict
        }
    }

    
    func testParse() throws {
        if let obj = GithubRootInfo.deserialize(from: self.dict) {
            XCTAssertTrue(obj.currentUserUrl == "https://api.github.com/user")
            XCTAssertTrue(obj.currentUserAuthorizationsHtmlUrl == "https://github.com/settings/connections/applications{/client_id}")
            XCTAssertTrue(obj.authorizationsUrl == "https://api.github.com/authorizations")
            XCTAssertTrue(obj.codeSearchUrl == "https://api.github.com/search/code?q={query}{&page,per_page,sort,order}")
            XCTAssertTrue(obj.commitSearchUrl == "https://api.github.com/search/commits?q={query}{&page,per_page,sort,order}")
            XCTAssertTrue(obj.emailsUrl == "https://api.github.com/user/emails")
            XCTAssertTrue(obj.emojisUrl == "https://api.github.com/emojis")
            XCTAssertTrue(obj.eventsUrl == "https://api.github.com/events")
            XCTAssertTrue(obj.feedsUrl == "https://api.github.com/feeds")
            XCTAssertTrue(obj.followersUrl == "https://api.github.com/user/followers")
            XCTAssertTrue(obj.followingUrl == "https://api.github.com/user/following{/target}")
            XCTAssertTrue(obj.gistsUrl == "https://api.github.com/gists{/gist_id}")
            XCTAssertTrue(obj.hubUrl == "https://api.github.com/hub")
            XCTAssertTrue(obj.issueSearchUrl == "https://api.github.com/search/issues?q={query}{&page,per_page,sort,order}")
            XCTAssertTrue(obj.issuesUrl == "https://api.github.com/issues")
            XCTAssertTrue(obj.keysUrl == "https://api.github.com/user/keys")
            XCTAssertTrue(obj.labelSearchUrl == "https://api.github.com/search/labels?q={query}&repository_id={repository_id}{&page,per_page}")
            XCTAssertTrue(obj.notificationsUrl == "https://api.github.com/notifications")
            XCTAssertTrue(obj.organizationUrl == "https://api.github.com/orgs/{org}")
            XCTAssertTrue(obj.organizationRepositoriesUrl == "https://api.github.com/orgs/{org}/repos{?type,page,per_page,sort}")
            XCTAssertTrue(obj.organizationTeamsUrl == "https://api.github.com/orgs/{org}/teams")
            XCTAssertTrue(obj.publicGistsUrl == "https://api.github.com/gists/public")
            XCTAssertTrue(obj.rateLimitUrl == "https://api.github.com/rate_limit")
            XCTAssertTrue(obj.repositoryUrl == "https://api.github.com/repos/{owner}/{repo}")
            XCTAssertTrue(obj.repositorySearchUrl == "https://api.github.com/search/repositories?q={query}{&page,per_page,sort,order}")
            XCTAssertTrue(obj.currentUserRepositoriesUrl == "https://api.github.com/user/repos{?type,page,per_page,sort}")
            XCTAssertTrue(obj.starredUrl == "https://api.github.com/user/starred{/owner}{/repo}")
            XCTAssertTrue(obj.starredGistsUrl == "https://api.github.com/gists/starred")
            XCTAssertTrue(obj.userUrl == "https://api.github.com/users/{user}")
            XCTAssertTrue(obj.userOrganizationsUrl == "https://api.github.com/user/orgs")
            XCTAssertTrue(obj.userRepositoriesUrl == "https://api.github.com/users/{user}/repos{?type,page,per_page,sort}")
            XCTAssertTrue(obj.userSearchUrl == "https://api.github.com/search/users?q={query}{&page,per_page,sort,order}")

        } else {
            XCTAssertTrue(false)
        }
    }
    
}
