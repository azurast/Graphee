//
//  FoldersController.swift
//  Graphee
//
//  Created by Nathanael DJ on 15/06/21.
//

import UIKit

class FoldersController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Sora-Bold", size: 32)!]
        self.navigationItem.title = "Folders"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddFolder))
    }
    
    //MARK - Selectors
    
    @objc func handleAddFolder(){
        self.present(UINavigationController(rootViewController: AddFolderController()), animated: true, completion: nil)
    }


}
