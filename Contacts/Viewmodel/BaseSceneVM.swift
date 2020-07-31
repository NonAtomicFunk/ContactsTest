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
    
        let tartuUrl: URL =  URL(string: Constants.tartuEmployeeList)!
        let tallinURL: URL = URL(string: Constants.tallinEmployeeList)!
        
        URLSession.shared.dataTask(with: tallinURL) { dataRaw, response, error in
            guard let data = dataRaw else {
                print("Error in Get Json")
                return
            }
            do {
                let list = try JSONDecoder().decode(EmployeeList.self, from: data)
                print("list", list)
                self.dataArray += list.employees

            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }.resume()
        
        URLSession.shared.dataTask(with: tartuUrl) { dataRaw, response, error in
            guard let data = dataRaw else {
                print("Error in Get Json")
                return
            }
            do {
                let list = try JSONDecoder().decode(EmployeeList.self, from: data)
                self.dataArray += list.employees

            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }.resume()
    }
}
