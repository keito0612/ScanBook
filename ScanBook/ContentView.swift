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
    @FetchRequest(
       entity: Category.entity(),
       sortDescriptors: [NSSortDescriptor(keyPath: \Category.id, ascending: false)],
       animation: .default
     ) var categorys: FetchedResults<Category>
    
    
    func loadData() {
        let categoryDatas: [String] = ["書類","漫画","小説"]
        if self.categorys.isEmpty {
            for categoryData in categoryDatas {
                let category = Category(context: self.viewContext)
                category.id = UUID()
                category.name = categoryData
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    
    @State var selection = 0
    init(){
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        VStack {
            LibraryPage().onAppear(perform: loadData)
        }.toolbarBackground(Color.black, for: .tabBar) .toolbarBackground(.visible, for: .tabBar) .toolbarColorScheme(.dark, for: .tabBar).accentColor(.white).background(Color.black)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PassCheck())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
