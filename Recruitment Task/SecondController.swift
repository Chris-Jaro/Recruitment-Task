//
//  SecondController.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 10/12/2020.
//

import UIKit

class SecondController: UIViewController {
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CommitCell", bundle: nil), forCellReuseIdentifier: "CommitCell")
        
        viewOnlineButton.layer.cornerRadius = 15
        shareRepoButton.layer.cornerRadius = 10
        
        navigationController?.navigationBar.tintColor = UIColor.white //These two lines change the batery color to white
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: - TableView DataSource Methods
extension SecondController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommitCell", for: indexPath) as! CommitCell
        return cell
    }

}


//MARK: - TableView Delgate Methods
extension SecondController: UITableViewDelegate {
    
}
