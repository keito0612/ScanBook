//
//  LibraryPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI
import CoreData
import AlertMessage

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
                            search(text: libraryModel.searchText)
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
                        }).padding(.trailing , 20).padding(.bottom , libraryModel.showSnack ? 80 : 10)
                    }
                }
            }.navigationTitle("ライブラリ")
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
        }.sheet(isPresented: $libraryModel.isAddPresented) {
            AddPage(isPresented: $libraryModel.isAddPresented, bookData: nil)
        }.alertMessage(isPresented: $libraryModel.showSnack,type: .snackbar) {
            HStack {
                Text(libraryModel.snackText).bold()
                    .foregroundColor(.white).padding(.vertical)
                  Spacer()
            }.padding(.horizontal).padding(.top).padding(.bottom, 60)
                .background(Color(white: 0.3, opacity: 1.0))
        }
    }
    
    private func search(text: String) {
        if text.isEmpty {
            bookDatas.nsPredicate = nil
        } else {
            let titlePredicate: NSPredicate = NSPredicate(format: "title  contains[c] %@", text)
            let categoryStatusPredicate: NSPredicate = NSPredicate(format: "categoryStatus contains %@", libraryModel.getCategoryStatusNumber(text))
            bookDatas.nsPredicate =  NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate,categoryStatusPredicate])
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
    @State var favorite :Bool
    init(bookData: BookData, context: NSManagedObjectContext, model: LibraryModel) {
        self.bookData = bookData
        self.context = context
        self.model = model
        _favorite = State(initialValue:bookData.favorito)
    }
    var body: some View{
        ZStack {
            VStack{
                if let coverImage = bookData.coverImage, let uiImage = UIImage(data: coverImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Bounds.width * 0.75, height: Bounds.height * 0.13).padding().padding(.top, 40)
                }else{
                    if(bookData.categoryStatus == 2){
                        Image(decorative: "folder")
                            .resizable()
                            .scaledToFit()
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
                        Button(action: {
                            if(favorite){
                                model.editFavorite(book:bookData, value: false, context: context)
                                model.snackText = "お気に入りを解除しました。"
                                favorite = false
                            }else{
                                model.editFavorite(book:bookData, value: true, context: context)
                                model.snackText = "お気に入りを登録しました。"
                                favorite = true
                            }
                            model.showSnack.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                model.showSnack.toggle()
                            }
                        }) {
                            Label(favorite ? "お気に入りを解除する": "お気に入りに登録する", systemImage: favorite ?  "heart.fill" :  "heart")
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
