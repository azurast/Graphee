//
//  FileManagerHelper.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import Foundation
import UIKit

public class FileManagerHelper {
    
    public static let instance = FileManagerHelper()
    private let folderImageName = "imageStorage"
    private let fileManager = FileManager.default
    
    public func preDefineImageStorageFolder() {
        // create imageStorage folder in document directory when the app first launch
        let preDefineFolderKey = "createdImageStorage"
        let defaults = UserDefaults.standard

        if defaults.bool(forKey: preDefineFolderKey) == false {
            configureDirectory()
            print("Success created image storage folder in document directory...")
            defaults.setValue(true, forKey: preDefineFolderKey)
        }
    }
    
    public func configureDirectory() {
        // create imageStorage folder in document directory when the app first launch
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(folderImageName)
        
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    public func getStoragePath() -> NSURL {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(folderImageName)
        
        let url = NSURL(string: path)
        
        return url!
    }
    
    public func saveImageToStorage(image: UIImage, imageName: String) {
        // save image as document to imageStorage folder
        let url = getStoragePath()

        let imagePath = url.appendingPathComponent(imageName)
        let urlString: String = imagePath!.absoluteString

        let imageData = image.jpegData(compressionQuality: 1)

        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
    }
    
    public func getImageFromStorage(imageName: String) -> UIImage? {
        var imageURL: URL?
        
        if let imagePath = (self.getStoragePath() as NSURL).appendingPathComponent("\(imageName)") {
            imageURL = imagePath
        }
        
        let urlString: String = imageURL!.absoluteString
        
        if fileManager.fileExists(atPath: urlString) {
            let image = UIImage(contentsOfFile: urlString)
            return image!
        } else {
            print("No Image")
            return nil
        }
        
    }
    
    public func deleteImageInStorage(imageName: String) {
        var imageURL: URL?
        
        if let imagePath = (self.getStoragePath() as NSURL).appendingPathComponent("\(imageName)") {
            imageURL = imagePath
        }
        
        if fileManager.fileExists(atPath: imageURL!.absoluteString) {
            try! fileManager.removeItem(atPath: imageURL!.absoluteString)
            print("Success remove image at storage folder..")
        }
    }
}
