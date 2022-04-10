//
//  CheckListDataModel.swift
//  Checklist
//
//  Created by Ajay Girolkar on 10/04/22.
//

import Foundation

struct CheckListDataModel: Codable, Identifiable {
    var id: String
    var isChecked: Bool
    var title: String?
}
