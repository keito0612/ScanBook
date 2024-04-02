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
    @Environment(\.managedObjectContext) private var viewContext
    @State var selection = 0
    
    init(){
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        ZStack{
            TabView (selection: $selection){
                HomePage().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                    .tabItem{
                    Image(systemName: "house")
                    Text("ホーム")
                }.tag(0)
                LibraryPage().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                    .tabItem {
                        Image(systemName: "books.vertical")
                        Text("ライブラリ")
                    }.tag(1)
                SettingPage()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("設定")
                    }.tag(2)
            }.toolbarBackground(Color.black, for: .tabBar) .toolbarBackground(.visible, for: .tabBar) .toolbarColorScheme(.dark, for: .tabBar).accentColor(.white).background(Color.black)
        } 
    }
    
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//            
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//    
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    //}
    
    //private let itemFormatter: DateFormatter = {
    //    let formatter = DateFormatter()
    //    formatter.dateStyle = .short
    //    formatter.timeStyle = .medium
    //    return formatter
    //}()
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
