//
//  RepositoryCell.swift
//  Recruitment Task
//
//  Created by Chris Yarosh on 10/12/2020.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var repoTitle: UILabel!
    @IBOutlet weak var starsNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
