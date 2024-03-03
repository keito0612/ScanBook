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
                                BookItemView(bookData: book, context: context, model: libraryModel).onTapGesture {
                                    
                                }
                            }
                        }.padding(.horizontal)
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingActionButton(onTap: {
                          libraryModel.isAddPresented.toggle()
                        }).padding(.trailing , 20)
                    }
                }
            }.navigationTitle("ライブラリ")
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
        }.sheet(isPresented: $libraryModel.isAddPresented) {
            AddPage(isPresented: $libraryModel.isAddPresented, bookData: nil)
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
            
        }
    }
}

struct BookItemView:View{
    let bookData: BookData
    let context: NSManagedObjectContext
    @ObservedObject var model : LibraryModel
    var body: some View{
        ZStack {
            VStack{
                if let coverImage = bookData.coverImage, let uiImage = UIImage(data: coverImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Bounds.width * 0.75, height: Bounds.height * 0.13).padding()
                }else{
                    if(bookData.categoryStatus == 2){
                        Image(decorative: "folder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: Bounds.width * 0.25, height: Bounds.height * 0.08).padding(.top, 30)
                    }else{
                        Image(decorative: "no_image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: Bounds.width * 0.35, height: Bounds.height * 0.13)
                    }
                }
                Text("カテゴリー：\(model.getCategoryStatusText(bookData.categoryStatus))").font(.system(size: 13)).foregroundStyle(Color.white).fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10).padding(.top,5)
                Text(bookData.title!).font(.system(size: 13)).foregroundStyle(Color.white).fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10).padding(.top,1)
                Text(UtilDate().DateTimeToString(date: bookData.date!)).font(.system(size: 12)).foregroundStyle(Color.white).fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center).padding(.top,1)
                Spacer()
            }.frame(width: Bounds.width * 0.4, height: Bounds.height * 0.21)
            VStack {
                HStack{
                    Spacer()
                    Menu{
                        Button(role: .destructive,action: {
                          model.dalete(book: bookData, context: context)
                        }) {
                            Label("削除", systemImage: "trash.fill")
                        }
                        Button(action: {
                            model.isEditPresented.toggle()
                        }) {
                            Label("編集", systemImage: "pencil")
                        }
                    }label: {
                        Image(systemName: "ellipsis").foregroundColor(.white).font(.system(size: 14))
                            .frame(width: Bounds.width * 0.06, height:Bounds.width * 0.06).background(Color.black).cornerRadius(70)  .overlay(
                                RoundedRectangle(cornerRadius: 70).stroke(Color.white, lineWidth: 2)
                            )
                    }.onTapGesture {
                        
                    }.padding(.top, 10).padding(.trailing, 22)
                }
                Spacer()
            }
        }.sheet(isPresented: $model.isEditPresented) {
            AddPage(isPresented: $model.isEditPresented, bookData: bookData)
        }
    }
    
}




struct LibraryPage_Previews: PreviewProvider {
    static var previews: some View {
        LibraryPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
