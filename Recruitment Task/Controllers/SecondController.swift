//
//  SecondController.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 10/12/2020.
//

import UIKit

class SecondController: UIViewController, RepoManagerDelegate, CommitManagerDelegate {
    
//    var repoPhotoURL: String = ""
//    var chosenRepoAuthorname: String = "Repo Author Name"
//    var numberOfStars: String = "234"
//    var chosenRepoTitle: String = "Repo Title"
//    var repoURL: String = ""
    
    var repoNumber: Int = 0
    
    var commitsURL: String = ""
    
    var repoManager = RepoManager()
    
    var commitManager = CommitManager()
    
    var commits: [CommitModel] = []
    
    @IBOutlet weak var viewOnlineButton: UIButton!
    @IBOutlet weak var shareRepoButton: UIButton!
    @IBOutlet weak var repoAuthorName: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var repoTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black //These two lines changes the batery color to white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommitCell", bundle: nil), forCellReuseIdentifier: "CommitCell")
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableView.automaticDimension
        
        viewOnlineButton.layer.cornerRadius = 15
        shareRepoButton.layer.cornerRadius = 10
        
//        repoAuthorName.text = chosenRepoAuthorname
//        starsLabel.text = "Number of Stars (\(numberOfStars))"
//        repoTitle.text = chosenRepoTitle
//        imageView.downloaded(from: repoPhotoURL)
        
        repoManager.delegate = self
        repoManager.fetchRepos()
        
        commitManager.delegate = self
        commitManager.fetchCommits(from: commitsURL)
        
        navigationController?.navigationBar.tintColor = UIColor.white //These two lines change the batery color to white
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.performRequest(with: self.commitsURL)
//        }

    }
    
    // For Commit Manager
    func updateUI(with list: [CommitModel] ) {
        commits = list
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // For Repo Manager
    func updateUI(with list: [RepoModel]) {
        DispatchQueue.main.async {
            self.repoAuthorName.text = list[self.repoNumber].repoOwner
            self.starsLabel.text = "Number of Stars (\(list[self.repoNumber].starNumber)"
            self.repoTitle.text = list[self.repoNumber].repoName
            self.imageView.downloaded(from: list[self.repoNumber].repoOwnerAvarat)
        }
        
//###############################################################################
//        commitsURL = list[repoNumber].commits_url
//        repoURL = list[repoNumber].html_url
//        chosenRepoTitle = list[repoNumber].repoName
//
    }

//    @IBAction func viewOnlineButtonPressed(_ sender: UIButton) {
//        if let url = URL(string: repoURL) {
//            UIApplication.shared.open(url)
//        }
//    }

    
//    @IBAction func shareRepoButtonPressed(_ sender: UIButton) {
//
//            let firstActivityItem = chosenRepoTitle
//
//            let secondActivityItem : NSURL = NSURL(string: repoURL)!
//
//            let image: UIImage = imageView.image!
//
//            let activityViewController : UIActivityViewController = UIActivityViewController(
//                activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
//
//            // This lines is for the popover you need to show in iPad
//            activityViewController.popoverPresentationController?.sourceView = self.view
//            // This line remove the arrow of the popover to show in iPad
//
//
//            // Pre-configuring activity items
//            activityViewController.activityItemsConfiguration = [
//            UIActivity.ActivityType.message
//            ] as? UIActivityItemsConfigurationReading
//
//            // Anything you want to exclude
//            activityViewController.excludedActivityTypes = [
//                UIActivity.ActivityType.postToWeibo,
//                UIActivity.ActivityType.print,
//                UIActivity.ActivityType.assignToContact,
//                UIActivity.ActivityType.saveToCameraRoll,
//                UIActivity.ActivityType.addToReadingList,
//                UIActivity.ActivityType.postToFlickr,
//                UIActivity.ActivityType.postToVimeo,
//                UIActivity.ActivityType.postToTencentWeibo,
//                UIActivity.ActivityType.postToFacebook
//            ]
//
//            activityViewController.isModalInPresentation = true
//            self.present(activityViewController, animated: true, completion: nil)
//
//    }
    
//    func performRequest(with urlString:String) {
//        let adjustedURL = urlString.replacingOccurrences(of: "{/sha}", with: "?per_page=3")
//        if let url = URL(string: adjustedURL){
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
//                        let decodedData = try jsonDecoder.decode([CommitData].self, from: safeData)
//                        self.decodeJSON(from: decodedData)
//
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
    
//    func decodeJSON(from data:[CommitData]){
//        for item in data{
//            commits.append(CommitModel(authorName: item.commit.author.name, authorEmail: item.commit.author.email, commitMessage: item.commit.message))
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    
}



//MARK: - TableView DataSource Methods
extension SecondController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommitCell", for: indexPath) as! CommitCell
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.numberLabel.layer.cornerRadius = 20
        
        cell.emailLabel.text = commits[indexPath.row].authorEmail
        cell.commitAuthorName.text = commits[indexPath.row].authorName.uppercased()
        cell.commitMessage.text = commits[indexPath.row].commitMessage
        
        return cell
    }

}
