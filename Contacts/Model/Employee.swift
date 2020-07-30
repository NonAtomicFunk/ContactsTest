//
//  Employee.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import Foundation

struct Employee: Decodable {
    let fname: String
    let lname: String
    let email: String
    let phone: String?
    let position: PositionType
    let project: ProjectType?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let employees = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .employees)
    }
}

enum PositionType: String {
    case iOS = "IOS"
    case android = "ANDROID"
    case web = "WEB"
    case pm = "PM"
    case tester = "TESTER"
    case sales = "SALES"
    case other = "OTHER"
}


enum ProjectType: String {
    case myCoolApp = "MyCoolApp"
    case oneTimeThing = "OneTimeThing"
}

enum CodingKeys: String, CodingKey {
    case employees = "employees"
    case fname = "fname"
    case lname = "lname"
    case contact_details = "contact_details"
    case email = "email"
    case phone = "phone"
    case posiiton = "posiiton"
    case projects = "projects"
}
