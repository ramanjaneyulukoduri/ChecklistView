//
//  CheckListDataModel.swift
//  Checklist
//
//  Created by Ajay Girolkar on 10/04/22.
//

import Foundation

//Structure to save Detail view screen information
struct CheckListDataModel: Codable, Identifiable {
    var id: String
    var isChecked: Bool
    var title: String?
}
