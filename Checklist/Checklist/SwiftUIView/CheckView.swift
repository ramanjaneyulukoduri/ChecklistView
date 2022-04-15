//
//  CheckView.swift
//  Checklist
//
//  Created by Ramanjaneyulu Koduri on 10/04/22.
//

import SwiftUI

//Checkview to use checkbox item to display in Master and Detail view.
struct CheckView: View {
    let id: Int
    var isChecked:Bool
    var title:String
    var checkBoxAction: (Int, Bool) -> Void

    var body: some View {
        HStack{
            Text(title)
            Spacer()
            Button(action: { //Button action to handle event when user click on checkbox button
                checkBoxAction(id, !isChecked)
            }) {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .foregroundColor(isChecked ? .green : .gray)
            }
        }
    }
}

#if DEBUG
struct CheckView_Previews: PreviewProvider {
    static var previews: some View {
        CheckView(id: 0, isChecked: true, title:"Title", checkBoxAction: {_, _ in })
    }
}
#endif
