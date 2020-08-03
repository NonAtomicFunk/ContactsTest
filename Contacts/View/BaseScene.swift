//
//  BaseScene.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import UIKit

class BaseScene: UIViewController {

    var dataArray: [Employee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getData()
    }
    
    private func displayAlert(_ errorText: String?) {

        let errorString: String = errorText ?? "Don't panic! Resistance is useless"
        let alert = UIAlertController(title: "Ooops",
                                      message: errorString,
                                      preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK: Parsing
extension BaseScene {
    
    public func getData() {
    
        let tartuUrl: URL =  URL(string: Constants.tartuEmployeeList)!
        let tallinURL: URL = URL(string: Constants.tallinEmployeeList)!
        
        let talinGroup = DispatchGroup()
        let tartuGroup = DispatchGroup()
        let talinQueque = DispatchQueue(label: "talinQueque",
                                       qos: .default,
                                       attributes: .concurrent,
                                       autoreleaseFrequency: .workItem,
                                       target: .none)
        let tartuQueque = DispatchQueue(label: "tartuQueque",
                                       qos: .default,
                                       attributes: .concurrent,
                                       autoreleaseFrequency: .workItem,
                                       target: .none)
        
        talinGroup.enter()
        tartuGroup.enter()
        
        let talinTask = URLSession.shared.dataTask(with: tallinURL) { dataRaw, response, error in
            talinQueque.async(group: talinGroup, qos: .default, flags: .barrier) {
                
                guard let data = dataRaw else {
                        return
                    }
                    do {
                        let list = try JSONDecoder().decode(EmployeeList.self, from: data)
                        print("list", list)
                        self.dataArray += list.employees
                        talinGroup.leave()
                    } catch let jsonErr {
                        
                        self.displayAlert(jsonErr.localizedDescription)
                    }
                }
        }
        talinTask.resume()
                    
        let tartuTask = URLSession.shared.dataTask(with: tartuUrl) { dataRaw, response, error in
            tartuQueque.async(group: tartuGroup, qos: .default, flags: .barrier) {
                
                guard let data = dataRaw else {
                        return
                    }
                    do {
                        let list = try JSONDecoder().decode(EmployeeList.self, from: data)
                        print("list", list)
                        self.dataArray += list.employees
                        tartuGroup.leave()
                    } catch let jsonErr {
                        
                        self.displayAlert(jsonErr.localizedDescription)
                    }
                }
        }
        tartuTask.resume()
    }
}

// MARK: CoreData
extension BaseScene {
    
}


// MARK: Table Delegate and data source
extension BaseScene {
    
}
