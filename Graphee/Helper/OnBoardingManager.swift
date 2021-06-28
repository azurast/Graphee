//
//  OnBoardingManager.swift
//  Graphee
//
//  Created by Dzaki Izza on 25/06/21.
//

import Foundation
import UIKit

class OnBoardingManager{
    
    static let shared = OnBoardingManager()
    
    var isFirstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: "firstLaunch")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "firstLaunch")
        }
    }
}
