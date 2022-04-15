//
//  DetailView.swift
//  Checklist
//
//  Created by Ramanjaneyulu Koduri on 10/04/22.
//

import SwiftUI

//This view display all information for checklist items
struct DetailView: View {
    @State var checkListDataModelArray : [CheckListDataModel] = []  //to save users entry in checklist items
    @State var checkListDataModelResetArray : [CheckListDataModel] = []
    @State var isEditing: Bool = false
    @State var isReset: Bool = false
    @State var textFieldEntry: String = ""
    @State var headerTextFieldEntry: String = ""
    let masterViewId: String
    @Binding var masterViewModelItems : [MasterViewDataModel] //to update view in parent screen when user update header items
    
    var body: some View {
        VStack {
            List() {
                getHeaderView()
                
                ForEach(checkListDataModelArray) { item in
                    CheckView(id: item.id,
                              isChecked: item.isChecked,
                              title: item.title ?? "",
                              checkBoxAction: checkBoxAction)
                } .onDelete(perform: deleteItems) //Delete entry from user
                if isEditing {
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
            }
            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
            .font(.body)
        }.toolbar {
            //To show buttons in navigation bar
            ToolbarItem(placement: .navigationBarTrailing) {
                
                if isEditing {
                    HStack {
                        Button(action: {
                            self.isReset.toggle()
                            resetButtonAction()
                        }) {
                            Text(isReset ? StringConstants.undoReset : StringConstants.reset)
                                .foregroundColor(isReset ? .red : .blue)
                        }
                        
                        Button(action: {
                            self.isEditing.toggle()
                            doneButtonAction()
                        }) {
                            Text(isEditing ? StringConstants.done : StringConstants.edit)
                        }
                    }
                } else {
                    Button(action: {
                        self.isEditing.toggle()
                    }) {
                        Text(StringConstants.edit)
                    }
                }
            }
        }.onAppear {
            updateModel()
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
    
    func updateModel() {
        if let unwrappedCheckListDataModel = UserDefaultManager().getDetailViewModel(identifier: masterViewId + StringConstants.childId) {
            checkListDataModelArray = unwrappedCheckListDataModel
            checkListDataModelResetArray = unwrappedCheckListDataModel
        }
    }
    
    func updateHeaderOnMasterView() {
        UserDefaultManager().updateMasterViewItem(id: masterViewId, masterViewDataModel: MasterViewDataModel(id: masterViewId, listItem: headerTextFieldEntry))
    }
    
    func doneButtonAction() {
        if !isEditing {
            checkListDataModelResetArray = checkListDataModelArray
            addItem(text: textFieldEntry)
            updateHeaderOnMasterView()
            textFieldEntry = ""
            updatedParentViewModel()
            syncChildViewModel()
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
    
    
    func checkBoxAction(id: String, text: String, isChecked: Bool) -> Void {
        updateCheckBoxItem(id: id, isChecked: isChecked)
        UserDefaultManager().updateChildViewItem(parentId: masterViewId + StringConstants.childId, childItemId: id, detailViewModel: CheckListDataModel(id: id, isChecked: isChecked, title: text))
    }
    
    //Update state of checkbox for individua row
    func updateCheckBoxItem(id: String, isChecked: Bool) {
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
            }
            return updatedmasterViewDataModel
        })
    }
    
    func syncChildViewModel() {
        checkListDataModelArray.forEach { checkListDataModel in
            UserDefaultManager().updateChildViewItem(parentId: masterViewId + StringConstants.childId, childItemId: checkListDataModel.id, detailViewModel: checkListDataModel)
        }
    }
    
    //Enter new entry to checklist
    private func addItem(text: String) {
        guard !text.isEmpty else { return }
        let id = text.replacingOccurrences(of: " ", with: "")
        let checkListDataModel = CheckListDataModel(id: id, isChecked: false, title: text)
        checkListDataModelArray.append(checkListDataModel)
    }
    
    func saveDetailViewModel(identifier: String, isChecked: Bool, title: String) {
        let checkListDataModel = CheckListDataModel(id: identifier, isChecked: isChecked, title: title)
        UserDefaultManager().saveDetailViewModel(identifier: masterViewId + StringConstants.childId, detailModel: checkListDataModel)
        updateModel()
    }
    
    //Delete entry from checklist
    private func deleteItems(offsets: IndexSet) {
        let itemToDelete = offsets.map { self.checkListDataModelArray[$0].id }
        checkListDataModelArray.remove(atOffsets: offsets)
        if let itemIdToDelete = itemToDelete.first {
            UserDefaultManager().deleteChildViewItem(parentId: masterViewId + StringConstants.childId, childItemId: itemIdToDelete)
        }
        updateModel()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(masterViewId: "", masterViewModelItems: .constant([]))
    }
}
