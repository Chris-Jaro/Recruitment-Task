//
//  CommitData.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 12/12/2020.
//

import Foundation

struct CommitData: Codable {
    let commit: Commit
}

struct Commit: Codable {
    let author: Author
    let message: String
}

struct Author: Codable {
    let name: String
    let email: String
}
