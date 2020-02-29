//
//  ContactTableCell.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 27/02/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import UIKit

struct ContactTableCellModel {
    var name: String
}

class ContactTableCell: TableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configure(_ item: Any?) {
        guard let model = item as? ContactTableCellModel else { return }
        self.nameLabel.text = model.name
    }

}
