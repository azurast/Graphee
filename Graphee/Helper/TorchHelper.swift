//
//  TorchHelper.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import Foundation
import UIKit
import AVFoundation

public class TorchHelper {
    public static let shared = TorchHelper()
    
    public func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            }
            catch {
                print("Torch could not be used because ", error.localizedDescription)
            }
        }
        else {
            print("Torch not available")
        }
    }
}
