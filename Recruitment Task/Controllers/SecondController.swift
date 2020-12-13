//
//  SecondController.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 10/12/2020.
//
// COMMENT REGARDING THE SCALED IMAGE:
//      I would use "aspect fit" given that all of avatars' images are squares it would look much more natural.
//      For the purpose of showing that I did change the color of the battery and time from back to white and to be closer to the image that was provided for this task
//      I left the image.comtentMode setting left on "scale to fill".

import UIKit

class SecondController: UIViewController {
    
    var commits: [CommitModel] = []
    
    var commitManager = CommitManager() // Creates an instance of commitManager object
    
    //# All the outlets from the storyBoard
    @IBOutlet weak var viewOnlineButton: UIButton!
    @IBOutlet weak var shareRepoButton: UIButton!
    @IBOutlet weak var repoAuthorName: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var repoTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    //# These two lines changes the batery color to white
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //# Ajdustments made to User Interface
        viewOnlineButton.layer.cornerRadius = 15
        shareRepoButton.layer.cornerRadius = 10
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableView.automaticDimension
        
        
        //# TableView implementation requirements
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommitCell", bundle: nil), forCellReuseIdentifier: "CommitCell") // required action to use the custom tableView Cell
        
        //# MVC implementatnion - connecting to Model
        commitManager.delegate = self
        if let repo = commitManager.repository {
            
            commitManager.fetchCommits(from: repo.commits_url)// Privides commits for the chosen repository
        }
    }

    //# Implementatnion of ViewOnline Button - where it takes user to Safari broser and opens repository's url
    @IBAction func viewOnlineButtonPressed(_ sender: UIButton) {
        if let repo = commitManager.repository {
            if let url = URL(string: repo.html_url ) {
                UIApplication.shared.open(url)
            }
        }
    }

    //# Implementatnion of ShareRepo Button - it opens activity view controller and allows shareing the link and the name of the repository
    @IBAction func shareRepoButtonPressed(_ sender: UIButton) {
        if let repo = commitManager.repository {
            let firstActivityItem = repo.repoName
            let secondActivityItem : NSURL = NSURL(string: repo.html_url)!
            let image: UIImage = imageView.image!
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)

            // Pre-configuring activity items
            activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading

            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToFacebook
            ]

            activityViewController.isModalInPresentation = true
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

//MARK: - CommitManagerDelegate Methods
extension SecondController: CommitManagerDelegate{
    
    //# Implementatnon of the protocol - it is triggered only when the URLRequest & jsonDecoding have been successful
    func updateUI(with list: [CommitModel] ) {
        //# Populates the tableView with 3 recent commits
        commits = list
        DispatchQueue.main.async {
            self.tableView.reloadData()
            //# Populates the outlets with the data provided for the chosen repository
            if let repo = self.commitManager.repository{
                self.repoAuthorName.text = repo.repoOwner
                self.starsLabel.text = "Number of Stars (\(repo.starNumber))"
                self.repoTitle.text = repo.repoName
                self.imageView.downloaded(from: repo.repoOwnerAvarat)
            }
        }
    }
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
