//
//  PreviewPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/03.
//



import SwiftUI
import WithPrevious

struct PreviewPage: View {
    let images : [UIImage]
    @State private var sliderValue: Int = 0
    @State @WithPrevious var page = 0
    @State var visibilityValue: Visibility = .visible
    let screenSizeWidth = UIScreen.main.bounds.width
    var body: some View {
            VStack{
                PageViewController(
                    pages: images.map{
                        Image(uiImage: $0)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .imageMagnificationView(contentSize: CGSize(width: screenSizeWidth , height: 600), aspectRatio: 1)
                    },
                    slidePageCount: $sliderValue,
                    currentPage: $page.animation()
                ).onTapGesture {
                    if(visibilityValue == .visible){
                       visibilityValue = .hidden
                    }else{
                      visibilityValue = .visible
                    }
                }
                
                if(visibilityValue == .visible){
                    Spacer()
                    BookSlider(slidePageCount: $sliderValue, pageCount: $page.animation(), maxPageCount: Double(images.count))
                }
            }.navigationBarTitle("", displayMode: .inline)
                .toolbarBackground(Color.black,for: .navigationBar)
                .toolbarBackground(visibilityValue, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .customBackButton(onBack: {})
        }
    }
struct PreviewPage_Previews: PreviewProvider {
    static let images :[UIImage] = []
    static var previews: some View {
        PreviewPage(images: images)
    }
}
