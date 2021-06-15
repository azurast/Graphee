//
//  PopupController.swift
//  Graphee
//
//  Created by Nathanael DJ on 14/06/21.
//

import UIKit

class PopupController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 15

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
