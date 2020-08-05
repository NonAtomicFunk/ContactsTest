//
//  DetailsScene.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import UIKit

class DetailsScene: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var projectsLabel: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    public var model: Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
    }
    
    func setupLabels() {
        guard self.model != nil else {
            return
        }
        
        self.nameLabel.text = model.fname+" "+model.lname
        
        self.emailLabel.text = "Name: "+model.email
        self.phoneLabel.text = model.phone
        self.positionLabel.text = "Position: "+model.position
        self.projectsLabel.text = model.project
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        
    }
}
