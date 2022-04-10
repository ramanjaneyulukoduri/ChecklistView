//
//  CheckListView.swift
//  CheckList
//
// Created by Ramanjaneyulu Koduri 09/04/22.
//

import SwiftUI

struct MasterView: View {
    
    @State var masterViewModelItems : [MasterViewDataModel] = []
    @State var isEditing: Bool = false
    @State var textFieldEntry: String = ""
    @State var updateFromChild: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                List() {
                    ForEach(masterViewModelItems) { item in
                        NavigationLink(destination: DetailView(headerTextFieldEntry: item.listItem ?? "",
                                                               masterViewId: item.id ?? "",
                                                               masterViewModelItems: $masterViewModelItems)) {
                            Text("\(item.listItem ?? "")")
                        }
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
                .font(.body)
            }.navigationTitle(StringConstants.checkList)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if isEditing {
                            Button(action: {
                                self.isEditing.toggle()
                                doneButtonAction()
                            }) {
                                Text(StringConstants.done)
                            }
                        } else {
                            EditButton()
                        }
                        
                    }
                    ToolbarItem {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Label(StringConstants.addItem, systemImage: ImageName.plus)
                        }
                    }
                }
        }
    }
    
    func doneButtonAction() {
        if !isEditing {
            addItem(text: textFieldEntry)
            textFieldEntry = ""
        }
    }
    
    private func addItem(text: String) {
        guard !text.isEmpty else { return }
        let id = text.replacingOccurrences(of: " ", with: "")
        let masterDetailModel = MasterViewDataModel(id: id, listItem: text)
        masterViewModelItems.append(masterDetailModel)
    }
    
    private func deleteItems(offsets: IndexSet) {
        masterViewModelItems.remove(atOffsets: offsets)
    }
}

struct CheckListView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
