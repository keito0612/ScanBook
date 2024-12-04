//
//  HomeView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/03/28.
//

import SwiftUI
import CoreData

struct HomePage: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.managedObjectContext) private var context
    //お気に入りリスト
    @FetchRequest(entity:BookData.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \BookData.date, ascending: false)],
                  predicate: NSPredicate(format:"favorito = %@", NSNumber(value: true)), animation: .default)
    private var favoriteBookDatas: FetchedResults<BookData>
    //続けるリスト
    @FetchRequest(entity:BookData.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \BookData.date, ascending: false)],
                  predicate: NSPredicate(format:"reading = %@", NSNumber(value: true)), animation: .default)
    private var readingBookDatas:FetchedResults<BookData>
    
     @StateObject var homeModel :HomeModel = HomeModel()
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    VStack{
                        sectionTitle("続ける")
                        ReadingZoomInHStackScrollView(readingBookDatas: readingBookDatas, model: homeModel).frame(height: readingListItemHeight)
                        sectionTitle("お気に入り")
                        FavoriteZoomInHStackScrollView(favoriteBookDatas: favoriteBookDatas, model: homeModel).frame(height:  favoriteListItemHeight)
                        Spacer()
                    }.padding(.top, 8)
            }.navigationBarTitle("ホーム" , displayMode: .inline)
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
        }
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .bold()
            .font(.system(size:Bounds.width * 0.07 ))
            .foregroundStyle(Color.white) .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
    }
    
    var readingListItemHeight: CGFloat {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return Bounds.height * 0.22
        }
        return Bounds.height * 0.15
    }
    
    var favoriteListItemHeight: CGFloat {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return Bounds.height * 0.4
        }
        return Bounds.height * 0.32
    }
}

struct ReadingZoomInHStackScrollView :View {
    let readingBookDatas : FetchedResults<BookData>
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @ObservedObject var model : HomeModel
    var body: some View {
        if(!readingBookDatas.isEmpty){
            GeometryReader { mainView in
                let mainViewSize = mainView.frame(in: .global).size
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(readingBookDatas){ book in
                            GeometryReader { item in
                                // スクロールによるズームイン・ズームアウトのスケールを計算
                                let scale = scale(mainFrame: mainView.frame(in: .global), itemFrame: item.frame(in: .global))
                                ReadingBookItemView(bookData: book, model: model)
                                    .frame(width: mainViewSize.width * 0.8 , height: mainViewSize.height * 0.9)
                                    .aspectRatio(contentMode: .fit)
                                // コンテンツのスケールを変える
                                    .scaleEffect(x: scale, y: scale, anchor: .top)
                            }
                            .frame(width: mainViewSize.width * 0.75 , height: mainViewSize.height)
                        }
                    }
                }
            }
        }else{
            VStack{
                Spacer()
                Text("現在、読んでいる物はありません。").font(.title2).foregroundStyle(.white).bold()
                Spacer()
            }
        }
        var readingFontSize: CGFloat {
            if horizontalSizeClass == .regular && verticalSizeClass == .regular {
                return Bounds.width * 0.04
            }
            return Bounds.width * 0.04
        }
    }
    private func scale(mainFrame: CGRect, itemFrame: CGRect) -> CGFloat {
        let scrollRate = itemFrame.minX  / mainFrame.width
        let scale = scrollRate + 1
        return min(max(0, scale), 1)
    }
}

struct FavoriteZoomInHStackScrollView :View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    let favoriteBookDatas: FetchedResults<BookData>
    @ObservedObject var model : HomeModel
    var body: some View {
        if(!favoriteBookDatas.isEmpty){
            GeometryReader { mainView in
                let mainViewSize = mainView.frame(in: .global).size
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(favoriteBookDatas){ book in
                            GeometryReader { item in
                                // スクロールによるズームイン・ズームアウトのスケールを計算
                                let scale = scale(mainFrame: mainView.frame(in: .global), itemFrame: item.frame(in: .global))
                                favoriteBookItemView(bookData: book, model: model)
                                    .frame(width: mainViewSize.width * 0.7, height: mainViewSize.height ).aspectRatio(contentMode: .fit)
                                    .padding(.leading,favoriteLeadingPaddingSize)
                                  
                                // コンテンツのスケールを変える
                                    .scaleEffect(x: scale, y: scale, anchor: .top)
                            }
                            .frame(width: mainViewSize.width * 0.75
                                , height: mainViewSize.height)
                            
                        }
                    }
                }
            }
        }else{
            VStack{
                Spacer()
                Text("現在、お気に入りはありません。").font(.title2).foregroundStyle(.white).bold()
                Spacer()
            }
        }
    }
    var favoriteLeadingPaddingSize: CGFloat {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return 60
        }
        return 25
    }
    private func scale(mainFrame: CGRect, itemFrame: CGRect) -> CGFloat {
        let scrollRate = itemFrame.minX  / mainFrame.width
        let scale = scrollRate + 1
        return min(max(0, scale), 1)
    }
}



struct ReadingBookItemView : View{
    let bookData: BookData
    @State var imagesCount : Int = 0
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @ObservedObject var model: HomeModel
    var body: some View{
        Button(action: {
            model.selectedReadingBookDataItem = BookDataItem(page: Page.preview, bookData: bookData)
        }, label: {
            VStack {
                HStack {
                    if let coverImage = bookData.coverImage, let uiImage = UIImage(data: coverImage) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: Bounds.width * 0.15,
                                   height: Bounds.height * 0.08)
                            .scaledToFill()
                            .padding(.all, readingPaddingSize)
                    }else{
                        if(bookData.categoryStatus == "書類"){
                            Image(systemName: "folder")
                                .foregroundStyle(.white)
                                .font(.system(size: Bounds.width * 0.142, weight: .medium))
                                .padding(.vertical, 14)
                        }else{
                            Image(decorative: "no_image")
                                .resizable()
                                .frame(width: Bounds.width * 0.2, height: Bounds.height * 0.1)
                                .aspectRatio(contentMode: .fill)
                             
                        }
                    }
                    VStack(alignment:.leading) {
                        Group{
                            Text("カテゴリー：\(bookData.categoryStatus)")
                                .font(.system(size: Bounds.width * 0.04))
                                .padding(.bottom,1)
                            Text(bookData.title ?? "" )
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .font(.system(size: Bounds.width * 0.04))
                           
                            bookData.images != nil ?  Text("\(bookData.pageCount + 1) / \(imagesCount)").font(.system(size: readingFontSize))
                                .padding(.top, 0.2)
                            :  Text("0/0").font(.system(size:  readingFontSize )).padding(.top, 0.2)
                                
                        }.foregroundStyle(Color.white).fontWeight(.bold)
                    }
                }.padding(.vertical,readingPaddingVerticalSize ).padding(.leading, 10).frame(width: Bounds.width * 0.65, alignment:.leading ).background(Color(white: 0.2, opacity: 1.0)).cornerRadius(Bounds.width * 0.09)
            }.fullScreenCover(item: $model.selectedReadingBookDataItem) { item in
                PreviewPage(images: [], bookData: item.bookData)
            }
        })
        .onAppear(perform: {
            if(bookData.images != nil ){
                self.imagesCount = Array<UIImage>.decode(from: bookData.images!).count
            }
        })
    }
    
    var readingPaddingSize: CGFloat {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return 15
        }
        return 12
    }
    
    var readingFontSize: CGFloat {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return Bounds.width * 0.04
        }
        return Bounds.width * 0.04
    }
    
    var readingPaddingVerticalSize: CGFloat{
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return Bounds.width * 0.03
        }
        return Bounds.width * 0.01
    }
    
}


struct favoriteBookItemView : View{
    let bookData: BookData
    @ObservedObject var model: HomeModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var body: some View{
        
        Button(action: {
            model.selectedFavoriteBookDataItem = BookDataItem(page: Page.preview, bookData: bookData)
        }, label: {
            VStack(spacing: 0){
                if let coverImage = bookData.coverImage, let uiImage = UIImage(data: coverImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: favoriteImageWidthSize, height: favoriteImageHightSize).padding(.vertical, favoriteImagePadding )
                       
                }else{
                    if(bookData.categoryStatus == "書類"){
                        Image(systemName: "folder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: favoriteImageWidthSize, height: favoriteImageHightSize)
                            .foregroundStyle(.white)
                            .padding(.vertical, favoriteImagePadding)
                    }else{
                        Image(decorative: "no_image")
                            .resizable()
                            .frame(width: Bounds.width * 0.45, height: Bounds.height * 0.2)
                            .scaledToFit()
                    }
                }
                Group{
                    Text("カテゴリー：\(bookData.categoryStatus)")
                        .font(.system(size: Bounds.width * 0.04))
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .padding(.bottom,4)
                    Text(bookData.title ?? "")
                        .font(.system(size: Bounds.width * 0.04))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                }.foregroundStyle(Color.white).fontWeight(.bold).padding([.leading, .trailing], favoriteTextHorizontalWithBottomPadding)
            }.padding(.horizontal).background(Color(white: 0.2, opacity: 1.0)).cornerRadius(Bounds.width * 0.1)
                .fullScreenCover(item: $model.selectedFavoriteBookDataItem) { item in
                    PreviewPage(images: [], bookData: item.bookData)
                }
        })
    }
    
    var favoriteImageWidthSize : CGFloat{
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return Bounds.width * 0.1
        } else if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            // Portrait (iPhone)
            return Bounds.width * 0.4
        }else{
            return Bounds.width * 0.35
        }
    }
    
    
    var favoriteImageHightSize : CGFloat{
    if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return Bounds.width * 0.03
        }
        return Bounds.height * 0.2
    }
    
    var favoriteImagePadding : CGFloat{
    if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return 40
        }
        return 10
    }
    
    var favoriteTextHorizontalWithBottomPadding : CGFloat{
    if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return 40
        }
        return 10
    }
    
    
}

#Preview {
   HomePage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
