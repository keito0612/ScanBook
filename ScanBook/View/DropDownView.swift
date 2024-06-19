//
//  DropDownView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/24.
//

import SwiftUI


struct DropDownView: View {
    @Binding<String> var value:String
    let lavel:String
    let dropItemList: [String]
    @Binding var errorValidation: Bool
    let errorText:String
    let onChange :(String) -> Void
    var body: some View {
        VStack{
            Text(lavel)
                .bold()
                .font(.system(size: Bounds.height * 0.02))
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Menu {
                ForEach(dropItemList, id: \.self) { item in
                    Button(action: {
                        value = item
                        onChange(item)
                    }) {
                        Text(item)
                    }
                }
            } label: {
                HStack {
                    Text(value).frame(maxWidth: .infinity, alignment: .leading).padding(.leading).foregroundColor(Color.white)
                        .font(.system(size: Bounds.width * 0.04))
                    
                    Image(systemName: "arrowtriangle.down.circle.fill").foregroundColor(Color.white).font(.system(size: Bounds.width * 0.04, weight: .medium)).padding()
                }.background(Color.black)
                    .frame(height: Bounds.height * 0.06)
                    .cornerRadius(Bounds.width * 0.06)
                    .overlay(
                        RoundedRectangle(cornerRadius: Bounds.width * 0.06)
                            .stroke( errorValidation ? Color.red : Color.white, lineWidth: 3)
                    ).frame(maxWidth: .infinity).padding(.horizontal)
            }
            if(errorValidation){
                Text(errorText)
                    .font(.system(size: 13))
                    .bold()
                    .foregroundColor(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
        }
    }
}

struct DropDownView_Previews: PreviewProvider {
    static let dropItemList : [String] =  ["カテゴリ","カテゴリー","カテゴリー"]
    static let lavel: String = "カテゴリー"
    @State static var value = "カテゴリ"
    static let errorText:String = "※カテゴリーを選択してください。"
    @State static var errorValidation: Bool = false
    static var previews: some View {
        DropDownView(value: $value,lavel: lavel, dropItemList: dropItemList,errorValidation: $errorValidation, errorText: errorText,onChange: {(value) in
        })
    }
}
