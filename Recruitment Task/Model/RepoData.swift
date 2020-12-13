//
//  RepoData.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 12/12/2020.
//

import Foundation

struct RepoData: Decodable{
    let items: [Repo] // List of repositories
    
}

struct Repo: Decodable{
    let name: String // For getting the title of the repo
    let owner: Owner // Accessing values of the repo author
    let html_url: String // For View Online
    let commits_url: String // For commits history
    let stargazers_count: Int // For getting the number of stars
    
}

struct Owner: Decodable {
    let avatar_url: String // For getting the image
    let login: String // For getting the author name
}
