//
//  UserDefaults.swift
//  CheckList
//
// Created by Ramanjaneyulu Koduri 14/04/22.
//

import Foundation


class UserDefaultManager {
    
    let userDefaults = UserDefaults.standard
    
    func save<T: Codable>(data: T, identifier: String) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            userDefaults.set(encodedData, forKey: identifier)
        } catch (let error) {
            print("failed to save data: \(error)")
        }
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
}
