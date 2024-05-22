//
//  ItemStore.swift
//  LootLogger
//
//  Created by R.AMOGH on 14/05/24.
//


import UIKit

class ItemStore{
    var allItems = [Item]()
    
    
    
    
    init(){
//        do {
//            let data = try Data(contentsOf: itemArchiveURL)
//            let unarchiver = PropertyListDecoder()
//            let items = try unarchiver.decode([Item].self, from: data)
//            // NOTE:- Because just [Items] creates an instance of that type.
//            //        But we need the type itself. Hence the '.self'.
//            allItems = items
//        }catch{
//            print("Error reading in saved items: \(error)")
//        }
//
//        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
        
    }
    
    
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first! // In IOS, there is always only one
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    
    
    @discardableResult func createItem()->Item{
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    func removeItem(_ item: Item){
        if let index = allItems.firstIndex(of: item){
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex:Int, to toIndex: Int) {
        if fromIndex == toIndex{
            return
        }
        
        // Get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        allItems.remove(at: fromIndex)
        
        //Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
    
    
    // Function to store the data (persistance)
    
    @objc func saveChanges()->Bool{
        print("Saving items to: \(itemArchiveURL)")
        
        do{
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allItems)
            try data.write(to: itemArchiveURL,options: [.atomic]) // atomic to ensure that there is no data corruption
            print("Saved all of items")
            return true
        }catch let encodingError{
            print("Error encoding allItemd: \(encodingError)")
            return false
        }
        
        
    }
    
    
    
    
}

