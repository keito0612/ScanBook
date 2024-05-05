//
//  PreviewPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/03.
//



import SwiftUI
import WithPrevious

struct PreviewPage: View {
    @Environment(\.managedObjectContext)private var context
    let images : [UIImage]
    let bookData:BookData?
    @State @WithPrevious var pageCount:Int
    @StateObject var previewModel: PreviewModel
    let screenSizeWidth = UIScreen.main.bounds.width
    
    init(images:[UIImage],bookData: BookData?){
        self.images = images
        self.bookData = bookData
        _previewModel = StateObject(wrappedValue: PreviewModel(bookData: bookData))
        if(bookData != nil ){
            pageCount = Int(bookData!.pageCount)
        }else{
            pageCount = 0
        }
    }
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack{
                PageViewController(
                    pages: images.map{
                        ImageViewer(image: $0).background(Color.black)
                    },
                    slidePageCount: $previewModel.sliderValue,
                    currentPage: $pageCount,
                    onChange:{ value  in
                        if(bookData != nil){
                            previewModel.editPageCount(context: context, pageCount: value)
                        }
                    }
                ).background(Color.black).onTapGesture {
                    if(previewModel.visibilityValue == .visible){
                        previewModel.visibilityValue = .hidden
                    }else{
                        previewModel.visibilityValue = .visible
                    }
                }
            }.navigationBarTitle("", displayMode: .inline)
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(previewModel.visibilityValue, for: .navigationBar)
                .toolbarColorScheme(.dark)
                .customBackButton(onBack: {})
            if(previewModel.visibilityValue == .visible){
                VStack(alignment: .trailing){
                    HStack(){
                        Spacer()
                        PreviewPageCountBar(imagesCount: images.count, pageCount: $pageCount).padding(.trailing, 10).padding(.top, 10)
                    }
                    Spacer()
                }
            }
        }.onAppear{
            
        }
    }
}

struct PreviewPageCountBar:View{
    let imagesCount: Int
    @Binding @WithPrevious var pageCount: Int
    var body: some View{
      ScrollView{
          Menu {
              ForEach(0..<imagesCount ,id: \.self){ page in
                  Button(action: {
                      pageCount = page
                  }) {
                      Text("\(page + 1)")
                  }
              }
          }label: {
              HStack{
                  Group{
                      Text("\(pageCount + 1) /").font(.system(size: 20)).foregroundStyle(.gray)
                      Text("\(imagesCount)").font(.system(size: 20))
                          .foregroundStyle(.gray)
                  }
              }.padding(.horizontal).background(Color.white)
                  .cornerRadius(30).frame(minWidth: 100.0)
          }
        }
    }
}


struct PreviewPage_Previews: PreviewProvider {
    static let images :[UIImage] = []
    static var previews: some View {
        PreviewPage(images: images, bookData: nil)
    }
}
