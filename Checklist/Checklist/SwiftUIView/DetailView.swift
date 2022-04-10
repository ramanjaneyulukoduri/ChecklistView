//
//  DetailView.swift
//  Checklist
//
//  Created by Ramanjaneyulu Koduri on 10/04/22.
//

import SwiftUI

struct DetailView: View {
    @State var checkListDataModelArray : [CheckListDataModel] = []
    @State var checkListDataModelResetArray : [CheckListDataModel] = []
    @State var isEditing: Bool = false
    @State var isReset: Bool = false
    @State var textFieldEntry: String = ""
    @State var headerTextFieldEntry: String = ""
    let masterViewId: String
    @Binding var masterViewModelItems : [MasterViewDataModel]
    
    var body: some View {
        VStack {
            List() {
                getHeaderView()
                
                ForEach(checkListDataModelArray) { item in
                    CheckView(id: item.id,
                              isChecked: item.isChecked,
                              title: item.title ?? "",
                              checkBoxAction: checkBoxAction)
                } .onDelete(perform: deleteItems)
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
        }
    }
    
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
    
    func doneButtonAction() {
        if !isEditing {
            checkListDataModelResetArray = checkListDataModelArray
            addItem(text: textFieldEntry)
            textFieldEntry = ""
            updatedParentViewModel()
        }
    }
    
    func resetButtonAction() {
        if isReset {
            checkListDataModelResetArray = checkListDataModelArray
            checkListDataModelArray.forEach { checkListDataModel in
                self.updateCheckBoxItem(id: checkListDataModel.id, isChecked: false)
            }
        } else {
            checkListDataModelArray = checkListDataModelResetArray
        }
    }
    
    
    func checkBoxAction(id: String, isChecked: Bool) -> Void {
        updateCheckBoxItem(id: id, isChecked: isChecked)
    }
    
    func updateCheckBoxItem(id: String, isChecked: Bool) {
        checkListDataModelArray = checkListDataModelArray.map({ checkListDataModel in
            var updateModel = checkListDataModel
            if updateModel.id == id {
                updateModel.isChecked = isChecked
            }
            return updateModel
        })
    }
    
    func updatedParentViewModel() {
        masterViewModelItems = masterViewModelItems.map({ masterViewDataModel in
            var updatedmasterViewDataModel = masterViewDataModel
            if updatedmasterViewDataModel.id == masterViewId {
                updatedmasterViewDataModel.listItem = headerTextFieldEntry
            }
            return updatedmasterViewDataModel
        })
    }
    
    private func addItem(text: String) {
        guard !text.isEmpty else { return }
        let id = text.replacingOccurrences(of: " ", with: "")
        let checkListDataModel = CheckListDataModel(id: id, isChecked: false, title: text)
        checkListDataModelArray.append(checkListDataModel)
    }
    
    private func deleteItems(offsets: IndexSet) {
        checkListDataModelArray.remove(atOffsets: offsets)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(masterViewId: "", masterViewModelItems: .constant([]))
    }
}
