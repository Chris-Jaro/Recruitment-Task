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
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black //These two lines changes the batery color to white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
