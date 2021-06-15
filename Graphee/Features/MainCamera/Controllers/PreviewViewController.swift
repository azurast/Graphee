//
//  PreviewViewController.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit

class PreviewViewController: UIViewController {

    private var topView: UIView!
    private var directionLabel: UILabel!
    private var photoImageView: UIImageView!
    private var bottomView: BottomCameraView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        setupNavigationView(statusBarHeight: height)
        setupBottomView()
        setupImageView(statusBarHeight: height)
        
    }
    
    private func setupNavigationView(statusBarHeight: CGFloat) {
        
        topView = UIView(frame: CGRect(x: 0, y:  statusBarHeight, width: view.frame.width, height: 80))
        topView.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        view.addSubview(topView)
        
        directionLabel = UILabel()
        directionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: topView.frame.width, height: 0))
        directionLabel.text = CameraImages.shared.getNextDirectionInString()
        directionLabel.textColor = .white
        directionLabel.numberOfLines = 0
        directionLabel.frame.size.height = directionLabel.intrinsicContentSize.height
        directionLabel.textAlignment = .center
        directionLabel.center = CGPoint(x: topView.frame.width / 2, y: topView.frame.height - 30)
        topView.addSubview(directionLabel)
    }

    private func setupBottomView() {
        let veryBottomView = UIView(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
        veryBottomView.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        view.addSubview(veryBottomView)
        
        bottomView = BottomCameraView(frame: CGRect(x: 0, y: view.frame.height - 150 - 50, width: view.frame.width, height: 150))
        bottomView.createPreviewButton()
        bottomView.previewButtonDelegate = self
        bottomView.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1).withAlphaComponent(0.5)
        view.addSubview(bottomView)
        
        if CameraImages.shared.isAllDictImageAvailable() {
            bottomView.hideDoneButton()
        }
    }
    
    private func setupImageView(statusBarHeight: CGFloat) {
        if CameraImages.shared.returnRatioFromDirection(direction: CameraImages.shared.getNextDirectionInString()) == SettingHelper.shared.ratio169 {
            photoImageView = UIImageView(frame: CGRect(x: 0, y: topView.frame.height + statusBarHeight, width: view.frame.width, height: view.frame.height - topView.frame.height - statusBarHeight - 50))
        } else if CameraImages.shared.returnRatioFromDirection(direction: CameraImages.shared.getNextDirectionInString()) == SettingHelper.shared.ratio43 {
            photoImageView = UIImageView(frame: CGRect(x: 0, y: topView.frame.height + statusBarHeight + 50, width: view.frame.width, height: view.frame.height - 50 - bottomView.frame.height - topView.frame.height - statusBarHeight - 50))
        } else {
            photoImageView = UIImageView(frame: CGRect(x: 0, y: topView.frame.height + statusBarHeight + 50, width: view.frame.width, height: view.frame.width))
        }
        
        photoImageView.image = CameraImages.shared.returnImageFromDirection(direction: CameraImages.shared.getNextDirectionInString())
        
        photoImageView.contentMode = .scaleAspectFit
        view.addSubview(photoImageView)
//        view.bringSubviewToFront(topView)
        view.bringSubviewToFront(bottomView)
    }

}

extension PreviewViewController: PreviewButtonDelegate {
    func previewDoneButtonTapped() {
        print(CameraImages.shared.isAllDictImageAvailable())
        if !CameraImages.shared.isAllDictImageAvailable() {
            CameraImages.shared.configureTheNextDirection()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func previewRetakeButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
