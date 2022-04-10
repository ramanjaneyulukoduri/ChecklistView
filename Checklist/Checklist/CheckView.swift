//
//  CheckView.swift
//  Checklist
//
//  Created by Ramanjaneyulu Koduri on 10/04/22.
//

import SwiftUI

struct CheckView: View {
    let id: String
    @State var isChecked:Bool
    var title:String
    
    var body: some View {
        HStack{
            Text(title)
            Spacer()
            Button(action: {
                isChecked.toggle()
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
        CheckView(id: "", isChecked: true, title:"Title")
    }
}
#endif
