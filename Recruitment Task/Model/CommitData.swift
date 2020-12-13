//
//  CommitData.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 12/12/2020.
//

import Foundation

struct CommitData: Decodable {
    let commit: Commit
}

struct Commit: Decodable {
    let author: Author
    let message: String
}

struct Author: Decodable {
    let name: String
    let email: String
}
