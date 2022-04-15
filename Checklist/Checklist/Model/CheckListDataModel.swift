//
//  CheckListDataModel.swift
//  Checklist
//
//  Created by Ramanjaneyulu Koduri on 10/04/22.
//

import Foundation

//Structure to save Detail view screen information
struct CheckListDataModel: Codable, Identifiable {
    var id: Int
    var isChecked: Bool
    var title: String?
}
