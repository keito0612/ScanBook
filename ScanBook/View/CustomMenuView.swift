//
//  CustomMenuView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/11/28.
//

import SwiftUI
import CoreData

import SwiftUI
import CoreData

import SwiftUI
import CoreData

struct CustomMenu: View {
    @Binding var isMenuOpen:Bool
    @Binding<String> var value:String
    @Binding var errorValidation:Bool
    let title:String
    let errorText:String
    let menuItems: [Category]
    let onChange :(String) -> Void
    let plusOnTap: () -> Void
    var body: some View {
            // トリガーボタン
            VStack {
                Text(title)
                    .bold()
                    .font(.system(size: Bounds.height * 0.02))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    withAnimation {
                        self.isMenuOpen.toggle()
                    }
                }) {
                    HStack {
                        Text(value == "" ? "選択してください。" : value ).frame(maxWidth: .infinity, alignment: .leading).padding(.leading).foregroundColor(Color.white)
                            .font(.system(size: Bounds.width * 0.04))
                        
                        Image(systemName: "arrowtriangle.down.circle.fill").foregroundColor(Color.white).font(.system(size: Bounds.width * 0.04, weight: .medium)).padding()
                    }.background(Color.black)
                        .frame(height: Bounds.height * 0.06)
                        .cornerRadius(Bounds.width * 0.06)
                        .overlay(
                            RoundedRectangle(cornerRadius: Bounds.width * 0.06)
                                .stroke( errorValidation ? Color.red : Color.white, lineWidth: 3)
                        ).frame(maxWidth: .infinity).padding(.horizontal)
                }.popover(isPresented: $isMenuOpen) {
                    MenuItem(isMenuOpen: self.$isMenuOpen , menuItems: menuItems, onChange:onChange, plusOnTap: plusOnTap) .presentationCompactAdaptation(.popover)
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

struct MenuItem: View{
    @Binding var isMenuOpen:Bool
    let menuItems:[Category]
    let onChange:(_ value:String) -> Void
    let plusOnTap: () -> Void
    var body:some View{
        GeometryReader { reader in
            HStack(spacing:0) {
                if(!menuItems.isEmpty){
                    ScrollView {
                            ForEach(menuItems, id: \.self) { item in
                                Button(action: {
                                    withAnimation {
                                        isMenuOpen.toggle()
                                    }
                                    onChange(item.name!)
                                }) {
                                    VStack {
                                        Text(item.name ?? "")
                                            .foregroundStyle(.white)
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .frame(width: reader.size.width * 0.75)
                                            .padding(.vertical, 12)
                                        Divider().background(.white)
                                    }
                                }
                            }
                        } .padding(.leading, 8)
                }else{
                    VStack {
                        Text("カテゴリはありません。")
                            .foregroundStyle(.white)
                            .bold()
                    }.frame(width: reader.size.width * 0.75)
                        .frame(height: reader.size.height)
                }
                Button(action: plusOnTap) {
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .medium))
                        .frame(width: reader.size.width * 0.20, height: reader.size.height)
                        .background(.black)
                        .foregroundColor(.white)
                }.frame(width: reader.size.width * 0.25) .overlay(
                    Rectangle()
                        .frame(width: 1)
                        .foregroundColor(.gray),
                    alignment: .leading
                )
            }
        }.frame(height: 50 * CGFloat(menuItems.count))
            .background(.black)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 4)
            )
            .shadow(radius: 5)
            .frame( width: Bounds.width * 0.7)
            .transition(.opacity)
      
    }
}


struct CustomMenu_Previews: PreviewProvider {
    @State static var isMenuOpen:Bool = true
    static let title: String = "カテゴリー"
    @State static var value = "選択してください。"
    static let errorText:String = "※カテゴリーを選択してください。"
    @State static var errorValidation: Bool = false
    static var previews: some View {
        CustomMenu(isMenuOpen: $isMenuOpen, value: $value, errorValidation: $errorValidation, title: title, errorText: errorText, menuItems: [], onChange: { value in
        }, plusOnTap: {})
    }
}
