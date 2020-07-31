//
//  Employee.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import Foundation

struct Employee: Decodable {
    var fname: String
//    var lname: String
//    var email: String
//    var phone: String?
//    var position: String //PositionType
//    var project: String? //ProjectType?
    
    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let employeeContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .employees)
//        let container = try container?.(keyedBy: CodingKeys.self, forKey: .employees)
//        fname = try container.decode(String.self, forKey: .fname)
//        lname = try container.decode(String.self, forKey: .lname)
//        let contsctDetails = try! container.nestedContainer(keyedBy: CodingKeys.self, forKey: .contact_details)
//        email = try contsctDetails.decode(String.self, forKey: .email)
//        phone = try? contsctDetails.decode(String.self, forKey: .phone)
//        position = try container.decode(String.self, forKey: .posiiton)
//        project = try? container.decode(String.self, forKey: .projects)
        print("!!!!", employeeContainer.allKeys)
        fname = try employeeContainer.decode(String.self, forKey: .fname)
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
