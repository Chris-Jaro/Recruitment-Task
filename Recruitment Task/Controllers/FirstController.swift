//
//  ViewController.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 10/12/2020.
//

import UIKit

class FirstController: UIViewController, RepoManagerDelegate {
    
//    var clickedRepoTitle: String = ""
//    var clickedRepoStars: Int = 0
//    var clickedRepoPhotoURL: String = ""
//    var clickedRepoAuthorName: String = ""
//    var clickedRepoCommitsURL: String = ""
//    var clickedRepoURL: String = ""
//
    var repositories: [RepoModel] = []
    
    var repoManager = RepoManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        
        searchBar.backgroundImage = UIImage() // Removes the 1px line
//        searchBar.delegate = self
        
        repoManager.delegate = self
        repoManager.fetchRepos()
        
    }
    
    func updateUI(with list: [RepoModel]) {
        repositories = list
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
//    func loadRepos(for query: String = "Swift"){
//        let queryURL = "https://api.github.com/search/repositories?q=\(query)&per_page=7"
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.performRequest(with: queryURL)
//        }
//    }
    
//    func performRequest(with urlString:String) {
//        if let url = URL(string: urlString){
//
//            let session = URLSession(configuration: .default)
//
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error != nil{
//                    print(error!)
//                    return
//                }
//
//                if let safeData = data{
//                    let jsonDecoder = JSONDecoder()
//                    do {
//                        let decodedData = try jsonDecoder.decode(RepoData.self, from: safeData)
//                        self.decodeJSON(from: decodedData)
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
    
//    func decodeJSON(from data:RepoData){
//        for item in data.items{
//            repositories.append(RepoModel(repoName: item.name, repoOwner: item.owner.login, repoOwnerAvarat: item.owner.avatar_url, html_url: item.html_url, commits_url: item.commits_url, starNumber: item.stargazers_count))
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "GoToTwo" {
//            if let desinationVC = segue.destination as? SecondController{
//                desinationVC.commitsURL = clickedRepoCommitsURL
//                desinationVC.repoURL = clickedRepoURL
//                desinationVC.chosenRepoAuthorname = clickedRepoAuthorName
//                desinationVC.chosenRepoTitle = clickedRepoTitle
//                desinationVC.numberOfStars = "\(clickedRepoStars)"
//                desinationVC.repoPhotoURL = clickedRepoPhotoURL
//
//            }
//        }
//    }
}

//MARK: - SearchBar Delegate Methods
//extension FirstController: UISearchBarDelegate{
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if let searchQuery = searchBar.text, searchBar.text?.count != 0{
//            repositories = [] // to show only the data of the query and not append it to the previous query results
//            loadRepos(for: searchQuery)
//        }
//    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//}



//MARK: - TableView DataSource Methods
extension FirstController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
        cell.layer.cornerRadius = 15
        cell.repoTitle.text = repositories[indexPath.section].repoName
        cell.starsNumber.text = "\(repositories[indexPath.section].starNumber)"
        cell.photo.layer.cornerRadius = 10
        cell.photo.downloaded(from: repositories[indexPath.section].repoOwnerAvarat)
        return cell
    }
    
    
}

//MARK: - TableView Delegate Methods
extension FirstController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        clickedRepoURL = repositories[indexPath.section].html_url
//        clickedRepoCommitsURL = repositories[indexPath.section].commits_url
//        clickedRepoTitle = repositories[indexPath.section].repoName
//        clickedRepoStars = repositories[indexPath.section].starNumber
//        clickedRepoPhotoURL = repositories[indexPath.section].repoOwnerAvarat
//        clickedRepoAuthorName = repositories[indexPath.section].repoOwner
        performSegue(withIdentifier: "GoToTwo", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBackground
        return headerView
    }
    
}
//MARK: - Extension for image downloading
extension UIImageView {
    func downloaded(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url)
    }
}
