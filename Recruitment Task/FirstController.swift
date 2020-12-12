//
//  ViewController.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 10/12/2020.
//

import UIKit

class FirstController: UIViewController {
    
    let queryURL = "https://api.github.com/search/repositories?q=swift"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        
        searchBar.backgroundImage = UIImage() // Removes the 1px line
    
        performRequest(with: queryURL)
    }

    
}
//MARK: - TableView DataSource Methods
extension FirstController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
        cell.layer.cornerRadius = 15
        return cell
    }
    
    
}

//MARK: - TableView Delegate Methods
extension FirstController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToTwo", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        return headerView
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
                        print(decodedData)
                        
                    } catch {
                        print(error)
                    }
                }
            }
        
            task.resume()
        }
    }
}

