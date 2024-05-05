//
//  HomeView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/03/28.
//

import SwiftUI
import CoreData

struct HomePage: View {
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
                ScrollView {
                    VStack{
                        Text("続ける")
                            .bold()
                            .font(.system(size:Bounds.width * 0.07 ))
                            .foregroundStyle(Color.white) .frame(maxWidth: .infinity, alignment: .leading).padding(.top, 8)
                        ReadingZoomInHStackScrollView(readingBookDatas: readingBookDatas, model: homeModel).frame(height: 200)
                        Text("お気に入り")
                            .bold()
                            .font(.system(size:Bounds.width * 0.07 ))
                            .foregroundStyle(Color.white) .frame(maxWidth: .infinity, alignment: .leading).padding(.top, 8)
                        FavoriteZoomInHStackScrollView(favoriteBookDatas: favoriteBookDatas, model: homeModel).frame(height: 400)
                    }.padding(.all, 10).padding(.horizontal, 5)
                }
            }.navigationBarTitle("ホーム" , displayMode: .inline)
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark)
        }
    }
}

struct ReadingZoomInHStackScrollView :View {
    let readingBookDatas : FetchedResults<BookData>
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
                                ReadingBookItemView(bookData: book, model: model, isPresent: $model.isPresentPreview)
                                    .frame(width: mainViewSize.width * 0.8  , height: mainViewSize.height * 0.9)
                                // コンテンツのスケールを変える
                                    .scaleEffect(x: scale, y: scale, anchor: .top)
                            }
                            .frame(width: mainViewSize.width * 0.76 , height: mainViewSize.height)
                        }
                    }
                }
            }
        }else{
            VStack{
                Spacer()
                Text("現在、読んでいる物はありません。").foregroundStyle(.white).bold()
                Spacer()
            }
        }
    }
    private func scale(mainFrame: CGRect, itemFrame: CGRect) -> CGFloat {
        let scrollRate = itemFrame.minX  / mainFrame.width
        let scale = scrollRate + 1
        return min(max(0, scale), 1)
    }
}

struct FavoriteZoomInHStackScrollView :View {
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
                                favoriteBookItemView(bookData: book, model: model, isPresent: $model.isPresentPreview)
                                    .frame(width: mainViewSize.width * 0.8  , height: mainViewSize.height * 0.9)
                                // コンテンツのスケールを変える
                                    .scaleEffect(x: scale, y: scale, anchor: .top)
                            }
                            .frame(width: mainViewSize.width * 0.76 , height: mainViewSize.height)
                        }
                    }
                }
            }
        }else{
            VStack{
                Spacer()
                Text("現在、お気に入りはありません。").foregroundStyle(.white).bold()
                Spacer()
            }
        }
    }
    private func scale(mainFrame: CGRect, itemFrame: CGRect) -> CGFloat {
        let scrollRate = itemFrame.minX  / mainFrame.width
        let scale = scrollRate + 1
        return min(max(0, scale), 1)
    }
}



struct ReadingBookItemView : View{
    let bookData: BookData
    let model: HomeModel
    @Binding var isPresent:Bool
    var body: some View{
        VStack(alignment:.leading){
            Group{
                Text("タイトル")
                Text("小説")
                Text("200/500").font(.system(size: 25))
            }.foregroundStyle(Color.white).fontWeight(.bold)
        }.padding(.horizontal).frame(width: 250, height: 130,alignment:.leading ).background(Color(white: 0.2, opacity: 1.0)).cornerRadius(30)
        
    }
}

struct favoriteBookItemView : View{
    let bookData: BookData
    let model: HomeModel
    @Binding var isPresent:Bool
    var body: some View{
        VStack(alignment:.leading){
            if let coverImage = bookData.coverImage, let uiImage = UIImage(data: coverImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Bounds.width * 0.5, height: Bounds.height * 0.2).padding()
            }else{
                if(bookData.categoryStatus == 2){
                    Image(decorative: "folder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Bounds.width * 0.5, height: Bounds.height * 0.2).padding(.top, 30)
                }else{
                    Image(decorative: "no_image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Bounds.width * 0.5, height: Bounds.height * 0.2)
                }
            }
            Group{
                Text("カテゴリー：\(model.getCategoryStatusText(bookData.categoryStatus))")
                Text(bookData.title!)
            }.foregroundStyle(Color.white).fontWeight(.bold)
        }.padding(.horizontal).frame(width: 250, height: 300,alignment:.leading ).background(Color(white: 0.2, opacity: 1.0)).cornerRadius(30)
            .sheet(isPresented: $isPresent) {
                PreviewPage(images:  Convert.convertBase64ToImages(bookData.images!.components(separatedBy: ",")), bookData: bookData)
            }
        
    }
    
}

#Preview {
    HomePage()
}
