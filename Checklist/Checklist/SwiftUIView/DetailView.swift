//
//  DetailView.swift
//  Checklist
//
//  Created by Ramanjaneyulu Koduri on 10/04/22.
//

import SwiftUI

//This view display all information for checklist items
struct DetailView: View {
    @Binding var masterViewModelItems : [MasterViewDataModel] {
        didSet {
            syncMasterViewItems()
        }
    } //to update view in parent screen when user update header items
    
    @State var checkListDataModelArray : [CheckListDataModel] = []  {
        didSet {
            updatedParentViewModel()
        }
    }
    @State var checkListDataModelResetArray : [CheckListDataModel] = []
    @State var isEditing: Bool = false
    @State var isReset: Bool = false
    @State var textFieldEntry: String = ""
    @State var headerTextFieldEntry: String = ""
    let masterViewId: Int
    
    var body: some View {
        VStack {
            List() {
                getHeaderView()
                
                ForEach(Array(checkListDataModelArray.enumerated()), id: \.offset) { (index, item) in
                    CheckView(id: index,
                              isChecked: item.isChecked,
                              title: item.title ?? "",
                              checkBoxAction: updateCheckBoxItem)
                } .onDelete(perform: deleteItems) //Delete entry from user
                    .onMove { IndexSet, index in
                        checkListDataModelArray.move(fromOffsets: IndexSet, toOffset: index)
                        updatedIndexOfArray()
                    }
                if isEditing {
                    addTextFieldView()
                }
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
            .font(.body)
        }.toolbar {
            //To show buttons in navigation bar
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    addEditModeHeaderView()
                } else {
                    Button(StringConstants.edit) {
                        self.isEditing.toggle()
                    }
                }
            }
        }.onAppear {
            updateModel()
        }
    }
    
    func updatedIndexOfArray() {
        for (index, item) in checkListDataModelArray.enumerated() {
            checkListDataModelArray = checkListDataModelArray.map({ checkListDataModel in
                var updatedCheckListDataModel = checkListDataModel
                if item.title == checkListDataModel.title {
                    updatedCheckListDataModel.id = index + 1
                }
                return updatedCheckListDataModel
            })
        }
    }
    
    //Return header view on top of List
    func getHeaderView() -> some View {
        HStack {
            if isEditing{
                TextField(headerTextFieldEntry, text: $headerTextFieldEntry)
                    .font(.title)
                
            } else {
                Text(headerTextFieldEntry)
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
    }
    
    
    func addTextFieldView() -> some View {
        HStack {
            Image(systemName: ImageName.plusCircle)
                .foregroundColor(.green)
            TextField(StringConstants.textFieldPlaceHolder, text: $textFieldEntry)
                .onSubmit {
                    addItem(text: textFieldEntry)
                    textFieldEntry = ""
                }
        }
    }
    
    func addEditModeHeaderView () -> some View {
        HStack {
            Button(action: {
                self.isReset.toggle()
                resetButtonAction()
            }) {
                Text(isReset ? StringConstants.undoReset : StringConstants.reset)
                    .foregroundColor(isReset ? .red : .blue)
            }
            
            Button(isEditing ? StringConstants.done : StringConstants.edit) {
                self.isEditing.toggle()
                doneButtonAction()
            }
        }
    }
    
    func updateModel() {
        checkListDataModelArray = masterViewModelItems.filter({$0.id == masterViewId}).first?.childItems ?? []
        checkListDataModelArray = checkListDataModelArray.sorted(by: {$0.id < $1.id})
        checkListDataModelResetArray = checkListDataModelArray
    }
    
    func doneButtonAction() {
        if !isEditing {
            checkListDataModelResetArray = checkListDataModelArray
            addItem(text: textFieldEntry)
            textFieldEntry = ""
        }
    }
    
    //Undo resetting checkbox status as before
    func resetButtonAction() {
        if isReset {
            checkListDataModelArray.forEach { checkListDataModel in
                self.updateCheckBoxItem(id: checkListDataModel.id, isChecked: false)
            }
        } else {
            checkListDataModelArray = checkListDataModelResetArray
            updateModel()
        }
    }
    
    //Update state of checkbox for individua row
    func updateCheckBoxItem(id: Int, isChecked: Bool) {
        checkListDataModelArray = checkListDataModelArray.map({ checkListDataModel in
            var updateModel = checkListDataModel
            if updateModel.id == id {
                updateModel.isChecked = isChecked
            }
            return updateModel
        })
    }
    
    //Updating name of items in parent screen if user update it in child screen
    func updatedParentViewModel() {
        masterViewModelItems = masterViewModelItems.map({ masterViewDataModel in
            var updatedmasterViewDataModel = masterViewDataModel
            if updatedmasterViewDataModel.id == masterViewId {
                updatedmasterViewDataModel.listItem = headerTextFieldEntry
                updatedmasterViewDataModel.childItems = checkListDataModelArray
            }
            return updatedmasterViewDataModel
        })
    }
    
    func syncMasterViewItems() {
        UserDefaultManager().save(data: masterViewModelItems,
                                  identifier: StringConstants.masterViewDataModelIdentifier)
    }
    
    //Enter new entry to checklist
    private func addItem(text: String) {
        guard !text.isEmpty else { return }
        let id = checkListDataModelArray.count + 1
        let checkListDataModel = CheckListDataModel(id: id, isChecked: false, title: text)
        checkListDataModelArray.append(checkListDataModel)
    }
    
    //Delete entry from checklist
    private func deleteItems(offsets: IndexSet) {
        checkListDataModelArray.remove(atOffsets: offsets)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(masterViewModelItems: .constant([]), masterViewId: 0)
    }
}
