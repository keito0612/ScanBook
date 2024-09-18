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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
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
                        Spacer().frame(height: Bounds.height * 0.13)
                        LazyVGrid(
                            columns: Array(repeating: .init(.flexible()), count: 2),
                            alignment: .center,
                            spacing: 30
                        ) {
                            ForEach(bookDatas, id: \.self) { bookData in
                                BookItemView(bookData: bookData, model: libraryModel)
                                
                            }
                        }.padding(.horizontal)
                        Spacer().frame(height: spacerFrameHeight)
                    }
                }
                VStack{
                    SearchBarView(searchText: $libraryModel.searchText, onSubmit: {
                        search(text: libraryModel.searchText)
                    }).padding(.vertical, 20)
                Spacer()
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingActionButton(onTap: {
                          libraryModel.isAddPresented.toggle()
                        }).padding(.trailing , 16).padding(.bottom , libraryModel.showSnack ? 150 : 80)
                    }
                }
            }.navigationTitle("ライブラリ")
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
        }.fullScreenCover(isPresented: $libraryModel.isAddPresented) {
            let addModel = AddModel(bookData: libraryModel.selectedBookDataItem?.bookData)
            AddPage(isPresented: $libraryModel.isAddPresented, bookDataItem: $libraryModel.selectedBookDataItem, addModel:addModel )
        }.alertMessage(isPresented: $libraryModel.showSnack,type: .snackbar) {
            HStack {
                Text(libraryModel.snackText).bold()
                    .foregroundColor(.white).padding(.vertical)
                  Spacer()
            }.padding(.horizontal).padding(.top).padding(.bottom, 120)
                .background(Color(white: 0.3, opacity: 1.0))
        }
    }
    
    var spacerFrameHeight : CGFloat{
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return 120
        }else{
            return 100
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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    let onTap: () -> Void
    var body: some View{
        Button {
            onTap()
        } label: {
          floatingActionButtonDesign
        }
    }
    var floatingActionButtonDesign: some View {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return Image(systemName: "plus")
                .font(.largeTitle)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
            
        }
        return Image(systemName: "plus")
            .font(.title.weight(.semibold))
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .clipShape(Circle())
            .shadow(radius: 4, x: 0, y: 4)
    }
}

struct BookItemView:View{
    var bookData: BookData
    @Environment(\.managedObjectContext)private var context
    @ObservedObject var model : LibraryModel
    init(bookData: BookData, model: LibraryModel) {
        self.bookData = bookData
        self.model = model
    }
    var body: some View{
        ZStack {
            Button(action: {
                model.selectedBookDataItem = BookDataItem(page: Page.preview, bookData: bookData)
                
            }, label: {
                VStack{
                    if let coverImage = bookData.coverImage, let uiImage = UIImage(data: coverImage) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: Bounds.width * 0.15, height: Bounds.height * 0.09).padding().padding(.top, 40)
                            .scaledToFit()
                    }else{
                        if(bookData.categoryStatus == 2){
                            Image(systemName: "folder")
                                .foregroundStyle(.white)
                                .font(.system(size: Bounds.height * 0.09, weight: .medium))
                                .padding(.top, 46)
                                .padding(.bottom, 15)
                        }else{
                            Image(decorative: "no_image")
                                .resizable()
                                .frame(width: Bounds.width * 0.35, height: Bounds.height * 0.09)
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    Text("カテゴリー：\(model.getCategoryStatusText(bookData.categoryStatus))").font(.system(size: Bounds.width * 0.03)).foregroundStyle(Color.white).fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top,4)
                    Text(bookData.title ??  "").font(.system(size:Bounds.width * 0.03)).foregroundStyle(Color.white).fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top,1)
                    Text(UtilDate().DateTimeToString(date: bookData.date ?? Date())).font(.system(size: Bounds.width * 0.03)).foregroundStyle(Color.white).fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading).padding(.top,1)
                    Spacer()
                }.frame(width: Bounds.width * 0.4, height: Bounds.height * 0.21)
            })
            VStack {
                HStack{
                    Spacer()
                    MenuTtripleDotButton(bookData: bookData, model: model)
                }
                Spacer()
            }.fullScreenCover(item: $model.selectedBookDataItem) { item in
                if(item.page == .preview ){
                    PreviewPage(images: [], bookData: item.bookData)
                }else{
                    AddPage(isPresented: $model.isAddPresented , bookDataItem: $model.selectedBookDataItem, addModel: AddModel(bookData:item.bookData ) )
                }
            }
        }
    }
}

struct MenuTtripleDotButton : View{
    var bookData: BookData
    @Environment(\.managedObjectContext)private var context
    @ObservedObject var model : LibraryModel
    @State var favorite :Bool
    init(bookData: BookData, model: LibraryModel) {
        self.bookData = bookData
        self.model = model
        _favorite = State(initialValue:bookData.favorito)
    }
    var body: some View{
        Menu{
            //削除
            Button(role: .destructive,action: {
                model.dalete(book: bookData, context: context)
            }) {
                Label("削除", systemImage: "trash.fill")
            }
            //編集
            Button(action: {
                model.selectedBookDataItem = BookDataItem(page: Page.edit, bookData: bookData)
            }) {
                Label("編集", systemImage: "pencil")
            }
            //お気に入り登録
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    model.showSnack.toggle()
                }
            }) {
                Label(favorite ? "お気に入りを解除する": "お気に入りに登録する", systemImage: favorite ?  "heart.fill" :  "heart")
            }
        }label: {
            ZStack {
                Circle().fill(Color.clear).frame(width: Bounds.width * 0.1, height:Bounds.width * 0.1).padding(.trailing, 12)
                Image(systemName: "ellipsis").foregroundColor(.white).font(.system(size: Bounds.width * 0.03 ))
                    .frame(width: Bounds.width * 0.06, height:Bounds.width * 0.06).background(Color.black).cornerRadius(70).overlay(
                        RoundedRectangle(cornerRadius: 70).stroke(Color.white, lineWidth: 2)
                    ).padding(.all, 10).padding(.trailing, 12)
            }
        }
    }
}




struct LibraryPage_Previews: PreviewProvider {
    static var previews: some View {
        LibraryPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
