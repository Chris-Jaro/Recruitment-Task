//
//  ViewController.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 10/12/2020.
//

import UIKit

class FirstController: UIViewController {
    
    var selectedSection: Int = 0 // Creating a reference to the chosen repository
    var repositories: [RepoModel] = [] // List of repositories to allow better functioning of the tableView
    var repoManager = RepoManager() // Creats an instance of the RepoManager object
    
    //# All the outlets form the storyBoard
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //# These two lines changes the batery color to black
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.black
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.backgroundImage = UIImage() // Removes the 1px line on the top and bottom of the searchBar
        
        //# TableView implementation requirements
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "RepositoryCell")
        //# SearchBar implementation requirements
        searchBar.delegate = self
        
        //# MVC implementatnion - connecting to Model
        repoManager.delegate = self
        repoManager.fetchRepos() // Provides basic list of repositories for default search query = "swift"
        
    }
    
    //# Actions made right before performing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTwo" {
            //# Changes backButton text to "Back" on the second screen
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
            
            //# Passing selected Repository to CommitManager of secondView to perform action with this data
            if let destinationVC = segue.destination as? SecondController{
                destinationVC.commitManager.repository = repositories[selectedSection]
            }
        }
    }
}

//MARK: - RepoManager Delegate Methods
extension FirstController: RepoManagerDelegate{
    //# Implementatnon of the protocol - it is triggered only when the URLRequest & jsonDecoding have been successful
    func updateUI(with list: [RepoModel]) {
        //# Populates the tableView with 7 repositories for a given searchQuery
        repositories = list
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}


//MARK: - SearchBarDelegate Methods
extension FirstController: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if let searchQuery = searchBar.text, searchBar.text?.count != 0{
            repositories = [] // to show only the data of the query and not append it to the previous query results
            repoManager.fetchRepos(for: searchQuery)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Toggles the keyboard on clicking "search"
    }
}



//MARK: - TableView DataSource Methods
extension FirstController: UITableViewDataSource{
    //# Using Sections here for the display in order to make the gap between the cells in the TableView
    
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
        selectedSection = indexPath.section // referenceNumber of the chosen repository
        performSegue(withIdentifier: "GoToTwo", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // width of the gap between the cells
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //# creates the gap between the cells
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
