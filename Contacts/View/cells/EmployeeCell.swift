//
//  EmployeeCell.swift
//  Contacts
//
//  Created by atomic on 03.08.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var contactsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contactsButton.isHidden = true // remove as CNContacts introduced
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setup(_ model: Employee) {
        self.nameLabel.text = model.lname+" "+model.fname
        self.positionLabel.text = model.position
    }
}
