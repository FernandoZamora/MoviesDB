//
//  TrailerTableViewCell.swift
//  Movies DB
//
//  Created by Fernando Zamora on 12/01/21.
//

import UIKit

class TrailerTableViewCell: UITableViewCell, Registrable, Dequeable {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TrailerTableViewCell: Configurable{
    typealias DataType = Trailer
    func configure(with data: Trailer) {
        self.nameLabel.text = data.name
    }
}
