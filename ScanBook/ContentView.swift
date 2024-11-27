//
//  ContentView.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/01/08.
//

import SwiftUI
import CoreData

enum Path: Hashable{
    case preview(Array<UIImage>)
    case edit
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .preview(let input):
            hasher.combine(input)
        case .edit: break
        }
    }
}
extension Path: Equatable {
    static func == (lhs: Path, rhs: Path) -> Bool {
        switch (lhs, rhs) {
        case (.preview, .preview), (.edit, .edit) :
            return true
        default:
            return false
        }
    }
}


struct ContentView: View {
    @Environment(\.managedObjectContext)private var viewContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @AppStorage(wrappedValue: 0, "appearanceMode") var appearanceMode
    @State var selection = 0
    init(){
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        VStack {
            LibraryPage()
        }.toolbarBackground(Color.black, for: .tabBar) .toolbarBackground(.visible, for: .tabBar) .toolbarColorScheme(.dark, for: .tabBar).accentColor(.white).background(Color.black)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PassCheck())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
