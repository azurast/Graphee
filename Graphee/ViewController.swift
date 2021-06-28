//
//  ViewController.swift
//  Graphee
//
//  Created by Azura Sakan Taufik on 08/06/21.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        
        view.addSubview(imageView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute:  {
            self.animate()
        })
    }
    
    
    
    private func animate() {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            let size = self.view.frame.size.width * 3
            
            let diffx = size - self.view.frame.size.width
            let diffy = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(x: -(diffx/2), y: diffy/2, width: size, height: size)
        
        })
        
    
        UIView.animate(withDuration: 0.5, animations: {
    self.imageView.alpha = 0

    }, completion: { done in
        
        if done {
            
            if OnBoardingManager.shared.isFirstLaunch {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:  {
            let storyboard = UIStoryboard(name: "AlbumFolderStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Album")
            
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
                
            })
        }
            else if !OnBoardingManager.shared.isFirstLaunch {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:  {
            let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnBoardingViewController")
                
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
                    
            })
                
        }
    }
})
        
    }
    
}


    


