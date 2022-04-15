//
//  CheckListView.swift
//  CheckList
//
// Created by Ramanjaneyulu Koduri 09/04/22.
//

import SwiftUI

struct MasterView: View {
    
    //State variable used to refresh view when any value in that screen changes. e.g adding new entry to checklist
    @State var masterViewModelItems : [MasterViewDataModel] = [] {
        didSet {
            syncMasterViewItems()
        }}
    @State var isEditing: Bool = false //to decide if screen is in editing mode so that we can delete entry if needed
    @State var textFieldEntry: String = "" //to store value entered by user while creating new entry
    @State var updateFromChild: Bool = false
    
    var body: some View {
        NavigationView { //this to show navigation bar on top of it.
            VStack {
                List() { //Scrollable view
                    ForEach(masterViewModelItems) { item in
                        //Navigation link to go to detail view on click on item
                        NavigationLink(destination: DetailView(masterViewModelItems: $masterViewModelItems,
                                                               headerTextFieldEntry: item.listItem,
                                                               masterViewId: item.id)) {
                            Text("\(item.listItem)")
                        }
                    } .onDelete(perform: deleteItems)
                        .onMove { IndexSet, index in
                            masterViewModelItems.move(fromOffsets: IndexSet, toOffset: index)
                            updatedIndexOfArray()
                        }
                    if isEditing {
                        addTextField()
                    }
                }
                .font(.body)
            }.navigationTitle(StringConstants.checkList)
                .toolbar { //to show edit and add button on navigation bar
                    ToolbarItem(placement: .navigationBarLeading) {
                        addEditModeHeaderView()
                    }
                    ToolbarItem {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Label(StringConstants.addItem, systemImage: ImageName.plus)
                        }
                    }
                }
        }.onAppear {
            updateModel()
        }
    }
    
    func addEditModeHeaderView () -> some View {
        HStack {
            if isEditing {
                Button(StringConstants.done) {
                    self.isEditing.toggle()
                    doneButtonAction()
                }
            } else {
                EditButton()
            }
        }
    }
    
    func addTextField() -> some View {
        HStack {
            Image(systemName: ImageName.plusCircle)
                .foregroundColor(.green)
            //Text field to get user's entry to add new item
            TextField(StringConstants.textFieldPlaceHolder, text: $textFieldEntry)
                .onSubmit {
                    addItem(text: textFieldEntry)
                    textFieldEntry = ""
                }
        }
        
    }
    
    func updateModel() {
        if let wrappedMasterViewModelItems = UserDefaultManager().getMasterViewItems() {
            masterViewModelItems = wrappedMasterViewModelItems
            masterViewModelItems = masterViewModelItems.sorted(by: {$0.id < $1.id})
        }
    }
    
    func syncMasterViewItems() {
        UserDefaultManager().save(data: masterViewModelItems, identifier:  StringConstants.masterViewDataModelIdentifier)
    }
    
    //Button action when user click on done button to save entry and update view.
    func doneButtonAction() {
        if !isEditing {
            addItem(text: textFieldEntry)
            textFieldEntry = ""
        }
    }
    
    func updatedIndexOfArray() {
        for (index, item) in masterViewModelItems.enumerated() {
            masterViewModelItems = masterViewModelItems.map({ checkListDataModel in
                var updatedCheckListDataModel = checkListDataModel
                if item.listItem == checkListDataModel.listItem {
                    updatedCheckListDataModel.id = index + 1
                }
                return updatedCheckListDataModel
            })
        }
    }
    
    private func addItem(text: String) {
        guard !text.isEmpty else { return }
        let id = masterViewModelItems.count + 1
        let masterDetailModel = MasterViewDataModel(id: id, listItem: text)
        masterViewModelItems.append(masterDetailModel)
    }
    
    //Delete item when user click on delete button
    private func deleteItems(offsets: IndexSet) {
        masterViewModelItems.remove(atOffsets: offsets)
    }
}

struct CheckListView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
