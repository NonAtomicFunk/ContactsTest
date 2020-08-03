//
//  Network.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import UIKit

class Network {
    
    static let shared = Network()
    
    private init() {
        
    }
    
    func getData(completion: @escaping ([Employee]) -> ()) {
        let tartuUrl: URL =  URL(string: Constants.tartuEmployeeList)!
        let tallinURL: URL = URL(string: Constants.tallinEmployeeList)!
        
        URLSession.shared.dataTask(with: tartuUrl) { dataRaw, response, error in
            guard let data = dataRaw else {
                print("Error in Get Json")
                return
            }
            
            do {
                let employeeList =  try JSONDecoder().decode([Employee].self, from: data)
                for employee in employeeList {
                    print("fname", employee.fname)
                    print("lname", employee.lname)
                    
                }
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }.resume()
    }
}
