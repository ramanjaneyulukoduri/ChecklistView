//
//  MasterView.swift
//  Checklist
//
//  Created by Ajay Girolkar on 10/04/22.
//

import SwiftUI

struct MasterView: View {
    var body: some View {
        NavigationView {
            List {
                CheckView(id: "1", isChecked: true, title: "Milk")
                CheckView(id: "2", isChecked: false, title: "Sugar")
                CheckView(id: "3", isChecked: true, title: "Bread")
                CheckView(id: "4", isChecked: false, title: "Buscuit")
            }.navigationTitle("Checklist")
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
