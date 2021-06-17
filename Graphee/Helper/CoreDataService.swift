//
//  CoreDataService.swift
//  Graphee
//
//  Created by Nathanael DJ on 16/06/21.
//

import Foundation
import CoreData
import UIKit

public class CoreDataService{
    public static let instance = CoreDataService()
    
    public let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //FETCH FOLDER
    public func fetchAllFolders() -> [Folder]? {
        
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
            let sort = NSSortDescriptor(key: "dateCreated", ascending: false)
            
            request.sortDescriptors = [sort]
            
            return try context.fetch(request) as? [Folder]
        } catch {
            print(error)
        }
        
        return nil
    }
    
    
    //DELETE FOLDER
    public func deleteFolder(folder: Folder) {
        self.context.delete(folder)
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    //SAVE FOLDER
    public func saveFolder(name: String) {
        let newFolder = Folder(context: self.context)
        newFolder.name = name
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    
}
