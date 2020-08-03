//
//  BaseScene.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import UIKit
import ContactsUI

class BaseScene: UIViewController {

    var rawDataArray = [Employee]()
//    var dataArray = [[Employee]]()
    var sections = [JobSection <String, Employee>]()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.viewModel = BaseSceneVM()
//        self.viewmo
        self.setupTable()
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
    
        // todo: CoreData
        
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
            talinQueque.async(group: talinGroup, qos: .userInitiated, flags: .assignCurrentContext) {
                
                guard let data = dataRaw else {
                        return
                    }
                    do {
                        let list = try JSONDecoder().decode(EmployeeList.self, from: data)
                        print("list", list)
                        self.rawDataArray += list.employees
                        talinGroup.leave()
                        DispatchQueue.main.async {
                            self.sortItems()
                        }
                    } catch let jsonErr {
                        
                        self.displayAlert(jsonErr.localizedDescription)
                    }
                }
        }
        talinTask.resume()
                    
        let tartuTask = URLSession.shared.dataTask(with: tartuUrl) { dataRaw, response, error in
            tartuQueque.async(group: tartuGroup, qos: .userInitiated, flags: .inheritQoS) {
                
                guard let data = dataRaw else {
                        return
                    }
                    do {
                        let list = try JSONDecoder().decode(EmployeeList.self, from: data)
                        self.rawDataArray += list.employees
                        tartuGroup.leave()
                        DispatchQueue.main.async {
                            self.sortItems()
                        }
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
extension BaseScene: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        self.dataArray.count
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.dataArray[section].count
        return self.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
        
        self.table.register(UINib(nibName: "EmployeeCell", bundle: nil),
        forCellReuseIdentifier: "EmployeeCell")
        
        let data = self.sections[indexPath.section].rows[indexPath.row]
        cell.setup(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let jobTitle = section.sectionItem
        return jobTitle
    }

    
    
    func setupTable() {
        self.table.dataSource = self
        self.table.delegate = self
        
        self.table.register(UINib(nibName: "EmployeeCell", bundle: nil),
                            forCellReuseIdentifier: "EmployeeCell")
    }
    
    func sortItems() {
        
        self.rawDataArray = self.rawDataArray.sorted(by: { (first, second) -> Bool in
            first.lname < second.lname
        })
        self.sections = JobSection.group(rows: self.rawDataArray, by: { $0.position })
        self.sections.sort { lhs, rhs in
            return lhs.sectionItem < rhs.sectionItem
        }
        
//        self.section
//        self.rawDataArray = self.rawDataArray.sorted { ($0.lname < $1.lname)}
        
        
        self.table.reloadData()
    }
}


//MARK: Contacts
extension BaseScene {
    
}
