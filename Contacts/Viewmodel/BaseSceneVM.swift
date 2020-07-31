//
//  BaseSceneVM.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import Foundation

class BaseSceneVM {
    var dataArray: [Employee] = [] {
        didSet {
            print("ARRAY count: ", dataArray.count)
        }
    }
    
    public func getData() {
    
        Network.shared.getData { (employees) in
            self.dataArray = employees
//            self.dataArray.append(employees)
        }
    }
}
