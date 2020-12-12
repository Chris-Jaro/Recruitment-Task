//
//  CommitCell.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 11/12/2020.
//

import UIKit

class CommitCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var commitAuthorName: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var commitMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
