//
//  BaseSceneVM.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import Foundation

class BaseSceneVM {
    public func getData() {
        
        Network.shared.getData { (employees) in
            print("ARRAY count: ", employees.count)
        }
    }
}
