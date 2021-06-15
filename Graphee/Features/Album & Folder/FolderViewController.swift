//
//  FolderViewController.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit

class FolderViewController: UIViewController {

    // Folder Array from CoreData (VARIABEL YG D BAWAH INI COBA2, DI DELETE AJA KALAU UDAH ADA DATA ASLI)
    public var productName: String?
    
    // INI Ubah tipe datanya jadi Folder
    public var directionArray = ["Front", "Back", "Right", "Left", "Detail"]
    
    @IBOutlet weak var folderCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
        
        folderCollectionView.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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

extension FolderViewController: UICollectionViewDelegate {
    
}

extension FolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = folderCollectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCollectionViewCell
        cell.directionLabel.text = directionArray[indexPath.row]
        
        cell.photoImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.4).isActive = true
        cell.photoImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width * 0.4).isActive = true
        cell.photoImageView.layer.cornerRadius = 10
        
        cell.photoImageView.image = UIImage(systemName: "photo")
        
        return cell
    }
    
    
}

extension FolderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("test")
        let height = view.frame.size.width * 0.4 + 26
        let width = view.frame.size.width
        
            // each size of cell will be 30%
        return CGSize(width: width * 0.4, height: height)
    }
}
