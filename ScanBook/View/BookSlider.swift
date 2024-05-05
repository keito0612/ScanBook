//
//  BookSlider.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/17.
//

import SwiftUI
import WithPrevious

struct BookSlider: View {
    @Binding private var slidePageCount:Int
    @Binding @WithPrevious var pageCount: Int
    let maxPageCount:Double
    init(slidePageCount: Binding<Int>,pageCount:Binding<WithPrevious<Int>> ,maxPageCount:Double) {
        self._slidePageCount =  slidePageCount
        self._pageCount = pageCount
        self.maxPageCount = maxPageCount
        UISlider.appearance().thumbTintColor = .blue
    }
    private var intProxy: Binding<Double> {
           Binding<Double>(
               get: {
                   Double(slidePageCount)
               }, set: {
                   slidePageCount = Int($0)
                   pageCount = Int($0)
               })
       }
    var body: some View {
        HStack {
            Text("\(slidePageCount + 1)/\(maxPageCount)").foregroundStyle(Color.white).font(.system(size: 20))
            Slider(value: self.intProxy, in: 0...maxPageCount,step: 1)
                .rotation3DEffect(.degrees(180),axis: (x: 0, y: 1, z: 0))
        }.padding(.horizontal).frame(height: 80).background(Color.gray)
    }
}

#Preview {
    @State var sliderPageValue: Int = 0
    @State @WithPrevious var pageCount = 0
    return BookSlider(slidePageCount: $sliderPageValue, pageCount: $pageCount , maxPageCount: 10)
}
