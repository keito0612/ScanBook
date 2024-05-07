//
//  PreviewModel.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/03/09.
//

import Foundation
import CoreData
import WithPrevious
import SwiftUI
class PreviewModel : ObservableObject {
    @Published  var sliderValue: Int = 0
    @Published  var aspectRatio: CGFloat = 1.0
    @Published  var visibilityValue: Visibility = .visible
    let bookData:BookData?
    init(bookData: BookData?) {
        self.bookData = bookData
    }
    
    func editPageCount(context : NSManagedObjectContext, pageCount: Int) {
        do{
            self.bookData!.pageCount = Int16(pageCount)
            if(pageCount != 0){
                editReading(context: context, reading: true)
            }else{
                editReading(context: context, reading: false)
            }
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private func editReading(context : NSManagedObjectContext,reading:Bool) {
        do{
            self.bookData!.reading = reading
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
