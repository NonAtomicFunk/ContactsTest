//
//  JobSection.swift
//  Contacts
//
//  Created by atomic on 03.08.2020.
//  Copyright © 2020 nonAtomicFunk. All rights reserved.
//

import Foundation


struct JobSection <SectionItem: Hashable, Employee> {

    var sectionItem : SectionItem
    var rows : [Employee]

    static func group(rows: [Employee], by criteria: (Employee) -> SectionItem) -> [JobSection <SectionItem, Employee>] {
        let groups = Dictionary(grouping: rows, by: criteria)
        return groups.map(JobSection.init(sectionItem: rows: ))
    }

}
