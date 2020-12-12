//
//  SecondController.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 10/12/2020.
//

import UIKit

class SecondController: UIViewController {
    
    
    var commitsURL: String = ""
    var repoURL: String = ""
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
        
        navigationController?.navigationBar.tintColor = UIColor.white //These two lines change the batery color to white
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.performRequest(with: self.commitsURL)
        }

    }

    
    @IBAction func viewOnlineButtonPressed(_ sender: UIButton) {
        if let url = URL(string: repoURL) {
            UIApplication.shared.open(url)
        }
    }
    
    
    func performRequest(with urlString:String) {
        let adjustedURL = urlString.replacingOccurrences(of: "{/sha}", with: "?per_page=4")
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
    
    func decodeJSON(from data:[CommitData]){
        for item in data{
            commits.append(CommitModel(authorName: item.commit.author.name, authorEmail: item.commit.author.email, commitMessage: item.commit.message))
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
