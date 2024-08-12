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
    @State var selection = 0
    init(){
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        ZStack {
            TabView (selection: $selection){
                ZStack{
                    HomePage()
                    VStack{
                        Spacer()
                        BannerView().frame(height:0).padding(.bottom, bannerPadding)
                    }
                }.tabItem{
                    Image(systemName: "house")
                    Text("ホーム")
                }.tag(0)
                ZStack{
                    LibraryPage()
                    VStack{
                        Spacer()
                        BannerView().frame(height:0).padding(.bottom, bannerPadding)
                    }
                }
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("ライブラリ")
                }.tag(1)
                ZStack{
                    SettingRootView()
                    VStack{
                        Spacer()
                        BannerView().frame(height:0).padding(.bottom, bannerPadding)
                    }
                }
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("設定")
                }.tag(2)
            }.toolbarBackground(Color.black, for: .tabBar) .toolbarBackground(.visible, for: .tabBar) .toolbarColorScheme(.dark, for: .tabBar).accentColor(.white).background(Color.black)
        }
        var bannerPadding :CGFloat{
            if horizontalSizeClass == .regular && verticalSizeClass == .regular {
                return  90
            }
            return 60
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
