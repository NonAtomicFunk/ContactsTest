//
//  BaseScene.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import UIKit

class BaseScene: UIViewController {

    var viewModel: BaseSceneVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = BaseSceneVM()
        self.viewModel.getData()
    }
}
