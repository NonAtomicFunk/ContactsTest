//
//  EmployeeRetrieveble.swift
//  Contacts
//
//  Created by atomic on 03.08.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import Foundation
import CoreData

class EmployeRetrievable: NSManagedObject, Decodable {
    @NSManaged var fname: String
    @NSManaged var lname: String
    @NSManaged var email: String
    @NSManaged var phone: String?
    @NSManaged var position: String
    @NSManaged var project: String?
    
    required convenience public init(from decoder: Decoder) throws {

        guard let contextUserInfoKey = CodingUserInfoKey.context,
        let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "EmployeeCoreData", in: managedObjectContext) else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
            
        do {
            fname = try container.decode(String.self, forKey: .fname)
            lname = try container.decode(String.self, forKey: .lname)
            let contsctDetails = try! container.nestedContainer(keyedBy: CodingKeys.self, forKey: .contact_details)
            email = try contsctDetails.decode(String.self, forKey: .email)
            phone = try? contsctDetails.decode(String.self, forKey: .phone)
            position = try container.decode(String.self, forKey: .position)
            project = try? container.decode(String.self, forKey: .projects)
        } catch {
            print ("error")
        }
    }
    
//    init(from decoder: Decoder) throws {
//       let container = try decoder.container(keyedBy: CodingKeys.self)
//
//       fname = try container.decode(String.self, forKey: .fname)
//       lname = try container.decode(String.self, forKey: .lname)
//       let contsctDetails = try! container.nestedContainer(keyedBy: CodingKeys.self, forKey: .contact_details)
//       email = try contsctDetails.decode(String.self, forKey: .email)
//       phone = try? contsctDetails.decode(String.self, forKey: .phone)
//       position = try container.decode(String.self, forKey: .position)
//       project = try? container.decode(String.self, forKey: .projects)
//   }
}
//
class EmployeeRetrievebleList: Decodable {
    var employees: [EmployeRetrievable]
}

//struct EmployeeList: Decodable {
//    var employees: [Employee]
//}
//
//enum CodingKeys: String, CodingKey {
//    case employees = "employees"
//    case fname = "fname"
//    case lname = "lname"
//    case contact_details = "contact_details"
//    case email = "email"
//    case phone = "phone"
//    case position = "position"
//    case projects = "projects"
//}
//
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}


//enum CodingKeys: String, CodingKey {
//    case employees = "employees"
//    case fname = "fname"
//    case lname = "lname"
//    case contact_details = "contact_details"
//    case email = "email"
//    case phone = "phone"
//    case position = "position"
//    case projects = "projects"
//}
