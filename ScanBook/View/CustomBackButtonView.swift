//
//  CustomBackButtonView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/02/15.
//

import Foundation
import SwiftUI
struct CustomBackButton: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    let onBack: () -> Void;

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            dismiss()
                            onBack()
                        }, label: {
                            Text("戻る").fontWeight(.bold)
                        }
                    ).tint(.white)
                }
            }
    }
}
