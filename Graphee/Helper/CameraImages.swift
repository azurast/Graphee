//
//  CameraImages.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import Foundation
import UIKit

public enum Direction: String {
    case front = "Front"
    case back = "Back"
    case right = "Right"
    case left = "Left"
    case detail = "Detail"
}

public class CameraImages {
    public static let shared = CameraImages()
    
    private var directionDict = [String:UIImage?]()
    private var directionRatio = [String:String]()
    public var mainCameraCapture = [String:Bool]()
    
    public var realImageDict = [String: UIImage?]()
    
    private var nextDirection = ""
    
    public func addImage(direction: String, image: UIImage?) {
        
        if let image = image {
            directionDict[direction] = image
        } else {
            directionDict[direction] = nil
        }
    }
    
    public func setStarterImageNil() {
        realImageDict[Direction.front.rawValue] = nil
        realImageDict[Direction.back.rawValue] = nil
        realImageDict[Direction.right.rawValue] = nil
        realImageDict[Direction.left.rawValue] = nil
        realImageDict[Direction.detail.rawValue] = nil
    }
    
    public func addRatio(direction: String, ratio: String) {
        directionRatio[direction] = ratio
    }
    
    public func returnRatioFromDirection(direction: String) -> String? {
        return directionRatio[direction] ?? nil
    }
    
    public func returnImageFromDirection(direction: String) -> UIImage? {
        
        return directionDict[direction] ?? nil
    }
    
    public func removeAllDictionary() {
        directionDict[Direction.front.rawValue] = nil
        directionDict[Direction.back.rawValue] = nil
        directionDict[Direction.right.rawValue] = nil
        directionDict[Direction.left.rawValue] = nil
        directionDict[Direction.detail.rawValue] = nil
    }
    
    public func getNextDirectionInString() -> String {
        return nextDirection
    }
    
    public func getNextDirectionInDirection() -> Direction {
        if nextDirection == "Front" {
            return .front
        } else if nextDirection == "Back" {
            return .back
        } else if nextDirection == "Right" {
            return .right
        } else if nextDirection == "Left" {
            return .left
        } else {
            return .detail
        }
    }
    
    public func getDirectionNilImage() -> [String]? {
        var nilImageDirection = [String]()
    
        if directionDict[Direction.front.rawValue] == nil {
            nilImageDirection.append(Direction.front.rawValue)
        }
        
        return nil
    }
    
    public func setNextDirection(direction: String) {
        nextDirection = direction
    }
    
    public func isAllDictImageAvailable() -> Bool {
        
        if directionDict[Direction.front.rawValue] == nil {
            return false
        } else if directionDict[Direction.back.rawValue] == nil {
            return false
        } else if directionDict[Direction.right.rawValue] == nil {
            return false
        } else if directionDict[Direction.left.rawValue] == nil {
            return false
        } else if directionDict[Direction.detail.rawValue] == nil {
            return false
        }
        
        return true
    }
    
    public func isAtLeastOneImageAvailable() -> Bool {
        if directionDict[Direction.front.rawValue] != nil {
            return true
        } else if directionDict[Direction.back.rawValue] != nil {
            return true
        } else if directionDict[Direction.right.rawValue] != nil {
            return true
        } else if directionDict[Direction.left.rawValue] != nil {
            return true
        } else if directionDict[Direction.detail.rawValue] != nil {
            return true
        }
        
        return true
    }
    
    public func configureTheNextDirection() {
        if !isAllDictImageAvailable() {
            let arrayOfDirections = [Direction.front.rawValue, Direction.back.rawValue, Direction.right.rawValue, Direction.left.rawValue, Direction.detail.rawValue]
            
            for (index, direction) in arrayOfDirections.enumerated() {
                if nextDirection == direction {
                    let startCountIndex = index + 1
                    
                    if direction != arrayOfDirections.last {
                        for index2 in startCountIndex...(arrayOfDirections.count - 1){
                            if returnImageFromDirection(direction: arrayOfDirections[index2]) == nil {
                                setNextDirection(direction: arrayOfDirections[index2])
                                return
                            }
                        }
                    }
                    
                    for index2 in 0...(startCountIndex - 1){
                        if returnImageFromDirection(direction: arrayOfDirections[index2]) == nil {
                            setNextDirection(direction: arrayOfDirections[index2])
                            return
                        }
                    }
                }
            }
        }
    }
}
