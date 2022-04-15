//
//  UserDefaults.swift
//  CheckList
//
// Created by Ramanjaneyulu Koduri 14/04/22.
//

import Foundation


class UserDefaultManager {
    
    let userDefaults = UserDefaults.standard
    
    func saveMasterViewItems(masterViewDataModel: MasterViewDataModel) {
        var masterDetailsArray: [MasterViewDataModel] = []
        if let masterDetailsArrayItem = getMasterViewItems() {
            masterDetailsArray = masterDetailsArrayItem
            masterDetailsArray.append(masterViewDataModel)
        } else {
            masterDetailsArray.append(masterViewDataModel)
        }
        save(data: masterDetailsArray, identifier: StringConstants.masterViewDataModelIdentifier)
    }
    
    func updateMasterViewItem(id: String, masterViewDataModel: MasterViewDataModel)  {
        deleteMasterViewItem(id: id)
        saveMasterViewItems(masterViewDataModel: masterViewDataModel)
    }
    
    func updateChildViewItem(parentId: String, childItemId: String, detailViewModel : CheckListDataModel) {
        deleteChildViewItem(parentId: parentId, childItemId: childItemId)
        saveDetailViewModel(identifier: parentId, detailModel: detailViewModel)
    }
    
    func deleteMasterViewItem(id: String) {
        if let masterDetailsArrayItem = getMasterViewItems() {
            let updatedMasterList = masterDetailsArrayItem.filter{($0.id != id)}
            save(data: updatedMasterList, identifier: StringConstants.masterViewDataModelIdentifier)
        }
    }
    func deleteChildViewItem(parentId: String, childItemId: String) {
        if let detailsViewArrayItem = getDetailViewModel(identifier: parentId) {
            let updatedDetailViewList = detailsViewArrayItem.filter{($0.id != childItemId)}
            save(data: updatedDetailViewList, identifier: parentId)
        }
    }
    
    func save<T: Codable>(data: T, identifier: String) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            userDefaults.set(encodedData, forKey: identifier)
        } catch (let error) {
            print("failed to save data: \(error)")
        }
    }
    
    func saveDetailViewModel(identifier: String, detailModel: CheckListDataModel) {
        var detailViewArray: [CheckListDataModel] = []
        if let detailViewArrayObject = getDetailViewModel(identifier: identifier) {
            detailViewArray = detailViewArrayObject
            detailViewArray.append(detailModel)
        } else {
            detailViewArray.append(detailModel)
        }
        save(data: detailViewArray, identifier: identifier)
    }
    
    func getMasterViewItems() -> [MasterViewDataModel]? {
        let decoder = JSONDecoder()
        do {
            if let data = userDefaults.object(forKey: StringConstants.masterViewDataModelIdentifier) as? Data {
                let masterViewDataArray = try decoder.decode([MasterViewDataModel].self, from: data)
                return masterViewDataArray
            }
        } catch (let error) {
            print("failed to get data: \(error)")
        }
        return nil
    }
    
    func getDetailViewModel(identifier: String) -> [CheckListDataModel]? {
        let decoder = JSONDecoder()
        do {
            if let data = userDefaults.object(forKey: identifier) as? Data {
                let detailViewArray = try decoder.decode([CheckListDataModel].self, from: data)
                return detailViewArray
            }
        } catch (let error) {
            print("failed to get data: \(error)")
        }
        return nil
    }
}
