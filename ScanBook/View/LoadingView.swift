//
//  LoadingView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/05/20.
//

import SwiftUI

struct LoadingView: ViewModifier {
    
    private let message:String
    private let scaleEffect: CGFloat
    private let isPresented:Binding<Bool>
    init(message:String,scaleEffect: CGFloat,isPresented:Binding<Bool>) {
        self.scaleEffect = scaleEffect
        self.message = message
        self.isPresented = isPresented
    }
    func body(content: Content) -> some View {
        content.fullScreenCover(isPresented:isPresented){
            loadingView().ignoresSafeArea(.all).background(SheetBackgroundClearView())
        }
    }
    
    private func loadingView() -> some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle( tint: Color.white))
                .scaleEffect(scaleEffect)
                .frame(width: scaleEffect * 20, height: scaleEffect * 20)
            Text(message)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(.title)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.gray.opacity(0.8))
    }
}




struct SheetBackgroundClearView: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIView {
        let view = SuperviewRecolourView()
        return view
    }

    func updateUIView(_: UIView, context _: Context) {}
}

class SuperviewRecolourView: UIView {
    override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}
