//
//  EmployeeProtocol.swift
//  Contacts
//
//  Created by atomic on 04.08.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import Foundation

protocol EmproyeeProtocol {
    var fname: String! { get set }
    var lname: String! { get set }
    var email: String! { get set }
    var phone: String? { get set }
    var position: String! { get set }
    var project: String? { get set }
}
