//
//  Employee.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import Foundation
import CoreData

struct Employee: Decodable {
    var fname: String
    var lname: String
    var email: String
    var phone: String?
    var position: String
    var project: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        fname = try container.decode(String.self, forKey: .fname)
        lname = try container.decode(String.self, forKey: .lname)
        let contsctDetails = try! container.nestedContainer(keyedBy: CodingKeys.self, forKey: .contact_details)
        email = try contsctDetails.decode(String.self, forKey: .email)
        phone = try? contsctDetails.decode(String.self, forKey: .phone)
        position = try container.decode(String.self, forKey: .position)
        project = try? container.decode(String.self, forKey: .projects)
    }
}

struct EmployeeList: Decodable {
    var employees: [Employee]
}


enum CodingKeys: String, CodingKey {
    case employees = "employees"
    case fname = "fname"
    case lname = "lname"
    case contact_details = "contact_details"
    case email = "email"
    case phone = "phone"
    case position = "position"
    case projects = "projects"
}
