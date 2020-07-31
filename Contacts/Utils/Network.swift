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
            
            let decoder = JSONDecoder()
                
            if let json = try? decoder.decode([Employee].self, from: data) {
                print("data", json)
                completion(json)
            } else {
                print("Error: ", error)
            }
        }.resume()
        
//        URLSession.shared.dataTask(with: tallinURL) { dataRaw, response, error in
//            guard let data = dataRaw else {
//                print("Error in Get Json")
//                return
//            }
//            
//            let decoder = JSONDecoder()
//                
//            if let json = try? decoder.decode([Employee].self, from: data) {
//                print("data", json)
//                completion(json)
//            } else {
//                print("Error: ", error)
//            }
//        }.resume()

        
        
    }
}
