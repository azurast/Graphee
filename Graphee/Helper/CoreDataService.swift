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
        let photos = folder.fetchAllPhotosFromFolder()
        
        if let currentPhotos = photos {
            for photo in currentPhotos {
                
                if let photoID = photo.directory {
                    FileManagerHelper.instance.deleteImageInStorage(imageName: photoID)
                }
                self.context.delete(photo)
            }
        }
        
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
        let photoArray = ["Front", "Back", "Right", "Left", "Detail"]
        
        let newFolder = Folder(context: self.context)
        newFolder.name = name
        newFolder.dateCreated = Date()
        
        for index in 0...4 {
            let newPhoto = Photo(context: self.context)
            newPhoto.directory = nil
            newPhoto.direction = photoArray[index]
            newPhoto.parentFolder = newFolder
        }
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    public func updateFolder(folder: Folder, name: String)
    {
        let currentFolder = folder
        
        currentFolder.name = name
        
        do {
            try self.context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    public func updatePhotoImage(photo: Photo, imageId: String) {
        let currentPhoto = photo
        currentPhoto.directory = imageId
        
        do {
            try self.context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
