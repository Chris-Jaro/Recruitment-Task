//
//  RepoManager.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 13/12/2020.
//

import Foundation

protocol RepoManagerDelegate {
    func updateUI(with list: [RepoModel])
}


struct RepoManager {

    var delegate: RepoManagerDelegate?
    
    func fetchRepos (for query: String = "Swift"){
        let queryURL = "https://api.github.com/search/repositories?q=swift&per_page=7"
        DispatchQueue.global(qos: .userInitiated).async {
            self.performRequest(with: queryURL)
        }
    }
    
    func performRequest(with urlString:String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    let jsonDecoder = JSONDecoder()
                    do {
                        let decodedData = try jsonDecoder.decode(RepoData.self, from: safeData)
                        self.decodeJSON(from: decodedData)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func decodeJSON(from data:RepoData){
        var repositories: [RepoModel] = []
        for item in data.items{
            repositories.append(RepoModel(repoName: item.name, repoOwner: item.owner.login, repoOwnerAvarat: item.owner.avatar_url, html_url: item.html_url, commits_url: item.commits_url, starNumber: item.stargazers_count))

        }
        delegate?.updateUI(with: repositories)

    }
}

