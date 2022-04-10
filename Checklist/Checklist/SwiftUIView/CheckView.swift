//
//  CheckView.swift
//  Checklist
//
//  Created by Ramanjaneyulu Koduri on 10/04/22.
//

import SwiftUI

struct CheckView: View {
    let id: String
    var isChecked:Bool
    var title:String
    var checkBoxAction: (String,  Bool) -> Void
    
    var body: some View {
        HStack{
            Text(title)
            Spacer()
            Button(action: {
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
        CheckView(id: "", isChecked: true, title:"Title", checkBoxAction: {_,_ in })
    }
}
#endif
