//
//  AddFolderController.swift
//  Graphee
//
//  Created by Nathanael DJ on 15/06/21.
//

import UIKit

class AddFolderController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    //MARK - Selectors
    
    @objc func handleDone(){
        
    }


}

