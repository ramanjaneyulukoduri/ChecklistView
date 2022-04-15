//
//  CheckListApp.swift
//  CheckList
//
// Created by Ramanjaneyulu Koduri 09/04/22.
//

import SwiftUI

@main
struct CheckListApp: App {
    @State var model: ChecklistDetails = CheckListApp.model
    static var model: ChecklistDetails = {
        do {
            let data  = try Data(contentsOf: CheckListApp.fileURL)
            let checkListData = try JSONDecoder().decode(ChecklistDetailsModel.self, from: data)
            let model = checkListData.ChecklistDetails
            return model
        } catch {
            print(error.localizedDescription)
        }
        return ChecklistDetails(lastUpdated: nil, header: "Checklist App",
                                masterViewItems: [MasterViewItems(id: "1", title: "Error", detailViewItems: nil)])
    }()
    static var modelBinding: Binding<ChecklistDetails>?
    
    var body: some Scene {
        CheckListApp.modelBinding = $model
        return WindowGroup {
            MasterView(checklistDetails: $model)
        }
    }
    
    static var fileURL: URL {
        let fileName = "ChecklistDetails.json"
        let fm = FileManager.default
        guard let documentDir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return URL(fileURLWithPath: "/") }
        let fileURL = documentDir.appendingPathComponent(fileName)
        return fileURL
    }
    
    static func save() {
        do {
            let data = try JSONEncoder().encode(modelBinding?.wrappedValue ?? model)
            try data.write(to: fileURL, options: .atomic)
            guard let dataString = String(data: data, encoding: .utf8) else { return }
            print(dataString)
        } catch {
            print("Could not write file: \(error)")
        }
    }
}
