//
//  CategoryListPage.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/12/03.
//

import SwiftUI
import CoreData

struct CategoryListPage: View {
    @Environment(\.managedObjectContext)private var viewContext
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.date, ascending: false)],
        animation: .default
    ) var categorys: FetchedResults<Category>
    @StateObject var categoryListViewModel:CategoryListViewModel = CategoryListViewModel()
    var body: some View {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    // カテゴリリスト
                    List {
                        ForEach(categorys) { category in
                            HStack {
                                Text(category.name ?? "未設定")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.listRowBackground(Color(white: 0.2, opacity: 1.0)).listRowSeparatorTint(.white)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        categoryListViewModel.deleteCategory(category: category , context: viewContext)
                                    } label: {
                                        Text("削除")
                                    }
                                    .tint(.red)
                                    
                                    Button {
                                        categoryListViewModel.category = category
                                        categoryListViewModel.alertText = category.name!
                                        categoryListViewModel.isEditing.toggle()
                                        categoryListViewModel.isPresented.toggle()
                                        
                                    } label: {
                                        Text("編集")
                                    }
                                    .tint(.blue)
                                }
                        }
                    }.scrollContentBackground(.hidden) // Listの背景を透過
                        .background(Color.black) // Listの背景を黒に設定
                }.navigationTitle("カテゴリ一覧").toolbarBackground(Color.black,for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarColorScheme(.dark)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        /// ナビゲーションバー左
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button(action: {
                                categoryListViewModel.isPresented.toggle()
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .customBackButton(onBack: {})
                    .alert(categoryListViewModel.isEditing ? "編集": "追加"  , isPresented: $categoryListViewModel.isPresented) {
                        TextField(categoryListViewModel.isEditing ? "": "新しいカテゴリ名", text: $categoryListViewModel.alertText)
                        
                        HStack {
                            Button {
                                categoryListViewModel.isPresented = false
                                categoryListViewModel.isEditing = false
                                categoryListViewModel.alertText = ""
                            } label: {
                                Text("キャンセル")
                            }
                            Button {
                                if( categoryListViewModel.isEditing){
                                    categoryListViewModel.isEditing = false
                                    let name = categoryListViewModel.alertText
                                    let category = categoryListViewModel.category
                                    categoryListViewModel.editCategory(category: category! , newName: name, context: viewContext)
                                }else{
                                    let name = categoryListViewModel.alertText
                                    categoryListViewModel.addCategory(name: name, context: viewContext)
                                }
                                categoryListViewModel.alertText = ""
                            } label: {
                                Text(categoryListViewModel.isEditing ? "編集": "追加")
                            }
                        }
                    }
            }
        }
    }


#Preview {
    NavigationStack {
        CategoryListPage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
