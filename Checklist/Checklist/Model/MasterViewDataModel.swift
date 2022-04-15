//
//  MasterViewDataModel.swift
//  Checklist
//
//  Created by Ramanjaneyulu Koduri on 10/04/22.
//

import Foundation

//Structure to store Master view screen information
struct MasterViewDataModel: Codable, Identifiable {
    var id: Int
    var listItem: String
    var childItems: [CheckListDataModel]?
}
