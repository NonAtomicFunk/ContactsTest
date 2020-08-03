//
//  BaseScene.swift
//  Contacts
//
//  Created by atomic on 30.07.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import UIKit
//import ContactsUI
import CoreData

class BaseScene: UIViewController {

    var rawDataArray = [Employee]()
    var employeesCoreDataArray: [NSManagedObject] = []
    var sections = [JobSection <String, Employee>]()
    
    @IBOutlet weak var table: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.retrieveCoreData()
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
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getData()
        refreshControl.endRefreshing()
    }
}


//MARK: Parsing
extension BaseScene {
    
    public func getData() {
        // todo: CoreData
        let tartuUrl: URL =  URL(string: Constants.tartuEmployeeList)!
        let tallinURL: URL = URL(string: Constants.tallinEmployeeList)!
        
        let group = DispatchGroup()
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
        
        group.enter()
        
        let talinTask = URLSession.shared.dataTask(with: tallinURL) { dataRaw, response, error in
            talinQueque.async(group: group, qos: .userInitiated, flags: .assignCurrentContext) {
                
                guard let data = dataRaw else {
                        return
                    }
                    do {
                        let list = try JSONDecoder().decode(EmployeeList.self, from: data)
                        
                        self.rawDataArray = list.employees
                        group.leave()
                    } catch let jsonErr {
                        
                        self.displayAlert(jsonErr.localizedDescription)
                    }
                }
        }
        talinTask.resume()
                    
        group.enter()
        let tartuTask = URLSession.shared.dataTask(with: tartuUrl) { dataRaw, response, error in
            tartuQueque.async(group: group, qos: .userInitiated, flags: .inheritQoS) {
                
                guard let data = dataRaw else {
                        return
                    }
                    do {
                        let list = try JSONDecoder().decode(EmployeeList.self, from: data)
                        self.rawDataArray += list.employees
                        
                        DispatchQueue.main.async {
                            self.sortItems()
                        }
                        group.leave()
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
    
    
    func retrieveCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeCoreData")
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let request: NSFetchRequest<EmployeeCoreData> = Employee.fetchRequest()
//        var coreDataArray = try managedContext.fetch(fetchRequest) //as [EmployeeCoreData]
//
//        // Then you can use your properties.
//
//        for location in locations {
//
//          print(location.name)
//
//        }
        
        
//        do {
//            var results = try managedContext.fetch(fetchRequest)
//            let coreDataArray: [EmployeeCoreData] = results as! [EmployeeCoreData]
//
////            for item in coreDataArray {
////                let employee = Employee(
////            }
//
//        } catch let error as NSError {
//            self.displayAlert("Could not fetch: \(error.localizedDescription)")
//        }
//        do {
//            self.rawDataArray = try managedContext.fetch(fetchRequest)
//        } catch {
//            self.displayAlert("Could not fetch: \(error.localizedDescription)")
//        }
        
    }
    
    func save(_ eployees: [Employee]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "EmployeeCoreData", in: managedContext)!
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "EmployeeCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            self.displayAlert(error.localizedDescription)
        }
        
        for model in eployees {
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            person.setValue(model.fname, forKey: "fname")
            person.setValue(model.email, forKey: "email")
            person.setValue(model.lname, forKey: "lname")
            person.setValue(model.phone, forKey: "phone")
            person.setValue(model.position, forKey: "position")
            person.setValue(model.project, forKey: "project")
            
            do {
                try managedContext.save()
                employeesCoreDataArray.append(person)
                
            } catch let error as NSError {
                self.displayAlert("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}


// MARK: Table Delegate and data source
extension BaseScene: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        self.table.addSubview(self.refreshControl)
    }
    
    func sortItems() {
        self.save(self.rawDataArray)
        self.rawDataArray = self.rawDataArray.sorted(by: { (first, second) -> Bool in
            first.lname < second.lname
        })
        self.sections = JobSection.group(rows: self.rawDataArray, by: { $0.position })
        self.sections.sort { lhs, rhs in
            return lhs.sectionItem < rhs.sectionItem
        }
        self.table.reloadData()
    }
}


//MARK: Contacts
extension BaseScene {
    
    func requestForAccess(completionHandler: (_ accessGranted: Bool) -> Void) {
        
//        CNContactStore().requestAccess(for: .contacts) { (access, error) in
//          print("Access: \(access)")
//        }
    }
}
