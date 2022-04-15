//
//  ChecklistDetailsModel.swift
//  Checklist
//
//  Created by Ramanjaneyulu Koduri on 13/04/22.
//

import Foundation

struct ChecklistDetailsModel: Codable {
    let ChecklistDetails: ChecklistDetails
}

struct ChecklistDetails: Codable {
    let lastUpdated: String?
    let header: String?
    let masterViewItems: [MasterViewItems]?
}


struct MasterViewItems: Codable, Identifiable {
    let id: String?
    let title: String?
    let detailViewItems: [CheckListDataModel]?
}
