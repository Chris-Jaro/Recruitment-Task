//
//  CommitManager.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 13/12/2020.
//

import Foundation

protocol CommitManagerDelegate {
    func updateUI(with list: [CommitModel])
}

struct CommitManager {
    
    var delegate: CommitManagerDelegate?
    
    var repository: RepoModel? // Instance of the chosen repository provided in prepare for segue function
    
    //# Function for fetching commits data from the web
    func fetchCommits(from commitsURL: String){
        DispatchQueue.global(qos: .userInitiated).async {
            self.performRequest(with: commitsURL)
        }
    }
    
    //# Function  that performs the URL request and provieds back the data
    func performRequest(with urlString:String) {
            let adjustedURL = urlString.replacingOccurrences(of: "{/sha}", with: "?per_page=3")
            if let url = URL(string: adjustedURL){
    
                let session = URLSession(configuration: .default)
    
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
    
                    if let safeData = data{
                        let jsonDecoder = JSONDecoder()
                        do {
                            let decodedData = try jsonDecoder.decode([CommitData].self, from: safeData)
                            self.decodeJSON(from: decodedData)
    
                        } catch {
                            print(error)
                        }
                    }
                }
                task.resume()
            }
        }
    
    //# Function that decodes the json file converts the data into CommitModel objects and sends it to the delegate to update user interface
    func decodeJSON(from data:[CommitData]){
            var commits: [CommitModel] = []
            for item in data{
                commits.append(CommitModel(authorName: item.commit.author.name, authorEmail: item.commit.author.email, commitMessage: item.commit.message))
            }
            delegate?.updateUI(with: commits)
        }
}
