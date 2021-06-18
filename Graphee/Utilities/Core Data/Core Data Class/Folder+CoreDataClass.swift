//
//  Folder+CoreDataClass.swift
//  Graphee
//
//  Created by Azura on 11/06/21.
//
//

import Foundation
import CoreData
import UIKit

@objc(Folder)
public class Folder: NSManagedObject {
    
    public func fetchFirstImageFromChild() -> String? {
        guard let photos = photos?.allObjects as? [Photo] else { return nil }
        
        for photo in photos {
            if photo.direction == Direction.front.rawValue {
                return photo.directory
            }
        }
        
        return nil
    }
    
    public func fetchAllPhotosFromFolder() -> [Photo]? {
        guard let photos = photos?.allObjects as? [Photo] else { return nil }
        return (photos.count > 0) ? photos : nil
    }
    
    public func fetchPhotosStatus() -> Int {
        guard let photos = photos?.allObjects as? [Photo] else { return 0 }
        var statusCount = 0
        
        for photo in photos {
            if photo.directory != nil {
                statusCount+=1
            }
        }
        
        return statusCount
    }
}

