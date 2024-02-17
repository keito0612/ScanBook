//
//  LibraryPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI

struct LibraryPage: View {
    @Environment(\.managedObjectContext)private var context
    @StateObject var libraryModel :LibraryModel  = LibraryModel()
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                ScrollView {
                    VStack{
                        SearchBarView(searchText: $libraryModel.searchText, onSubmit: {
                          
                        }).padding(.vertical, 20)
                        LazyVGrid(
                            columns: Array(repeating: .init(.flexible()), count: 3),
                            alignment: .center,
                            spacing: 30
                        ) {
                            ForEach(0..<5) { i in
                                Color.red }.frame(width: 110, height: 150)
                        }.padding(.horizontal)
                    }
                }
                VStack {
                    Spacer()
                    FloatingActionButton(onTap: {
                      libraryModel.isPresented.toggle()
                    }).padding(.leading , 320)
                }
            }.navigationTitle("ライブラリ")
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
        }.sheet(isPresented: $libraryModel.isPresented) {
            AddPage()
        }
    }
}
struct FloatingActionButton: View{
    let onTap: () -> Void
    var body: some View{
        Button {
            onTap()
        } label: {
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
            
        }.padding()
    }
}




struct LibraryPage_Previews: PreviewProvider {
    static var previews: some View {
        LibraryPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
