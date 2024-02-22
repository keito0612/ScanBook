//
//  LibraryPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI
import CoreData

struct LibraryPage: View {
    @Environment(\.managedObjectContext)private var context
    @StateObject var libraryModel :LibraryModel  = LibraryModel()
    @FetchRequest(entity:BookData.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \BookData.date, ascending: false)],
           animation: .default)
    private var bookDatas: FetchedResults<BookData>
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
                            columns: Array(repeating: .init(.flexible()), count: 2),
                            alignment: .center,
                            spacing: 30
                        ) {
                            ForEach(bookDatas) { book in
                              BookItemView(book: book)
                            }
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
            AddPage(isPresented: $libraryModel.isPresented)
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

struct BookItemView:View{
    let book: BookData
    var body: some View{
        VStack{
            if let coverImage = book.coverImage, let uiImage = UIImage(data: coverImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Bounds.width * 0.35, height: Bounds.height * 0.13).padding()
            }else{
                if(book.categoryStatus == 2){
                    Image(decorative: "folder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Bounds.width * 0.35, height: Bounds.height * 0.13).padding(.top, 30)
                }else{
                    Image(decorative: "no_image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Bounds.width * 0.35, height: Bounds.height * 0.13)
                }
            }
            Text(book.title!).font(.system(size: 13)).foregroundStyle(Color.white).fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10).padding(.top,5)
            Spacer()
        }.frame(width: Bounds.width * 0.4, height: Bounds.height * 0.27).border(Color.white, width: 2)
    }
}




struct LibraryPage_Previews: PreviewProvider {
    static var previews: some View {
        LibraryPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
