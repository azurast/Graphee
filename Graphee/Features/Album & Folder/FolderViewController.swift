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
    public var parentFolder: Folder?
    private var directionArray: [Photo?] = [nil, nil, nil, nil, nil]
    private var images = [UIImage]()
    
    private var isFirstTime = true
    
    @IBOutlet weak var folderCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(named: "AccentColor")
        
        folderCollectionView.backgroundColor = UIColor.init(named: "DarkColor")
        
        self.title = parentFolder?.name
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "DarkColor")]
        
        fetchPhotos()
        
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAction), name: Notification.Name("updateAction"), object: nil)
        
    }
    
    @objc private func updateAction() {
        updateUI()
    }
    
    private func updateUI() {
        fetchPhotos()
        reloadCollectionView()
    }
    
    public func reloadCollectionView() {
        DispatchQueue.main.async {
            self.folderCollectionView.reloadData()
        }
    }
    
    public func fetchPhotos() {
        let photoArray = parentFolder!.fetchAllPhotosFromFolder()!
        
        for photo in photoArray {
            if photo.direction == "Front" {
                directionArray[0] = photo
            } else if photo.direction == "Back" {
                directionArray[1] = photo
            } else if photo.direction == "Right" {
                directionArray[2] = photo
            } else if photo.direction == "Left" {
                directionArray[3] = photo
            } else if photo.direction == "Detail" {
                directionArray[4] = photo
            }

        }
        
        print(directionArray[0]?.directory)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.largeTitleDisplayMode = .always
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func navigateToPhotoDetailStoryboard(indexPath: IndexPath) {
        folderCollectionView.deselectItem(at: indexPath, animated: true)
        
        let photoDetailStoryboard = UIStoryboard(name: "PhotoDetailStoryboard", bundle: nil)
        let photoDetailViewController = photoDetailStoryboard.instantiateViewController(identifier: "photoDetailStoryboard") as! PhotoDetailViewController
        
        photoDetailViewController.title = directionArray[indexPath.row]?.direction
        photoDetailViewController.initialIndexPath = indexPath
        photoDetailViewController.imageArray = self.images
        photoDetailViewController.directionArray = self.directionArray
        photoDetailViewController.parentFolder = self.parentFolder
        
        self.navigationController?.pushViewController(photoDetailViewController, animated: true)
    }
    
}

extension FolderViewController: UICollectionViewDelegate {
    
}

extension FolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = folderCollectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCollectionViewCell
        cell.directionLabel.text = directionArray[indexPath.row]?.direction
        
        if isFirstTime {
            let size = (collectionView.frame.size.width - 60) / 2
            
            cell.photoImageView.widthAnchor.constraint(equalToConstant: size).isActive = true
            cell.photoImageView.heightAnchor.constraint(equalToConstant: size - cell.directionLabel.frame.height).isActive = true
        }
        
        cell.photoImageView.layer.cornerRadius = 10
        
        let imageID = directionArray[indexPath.row]?.directory
        if let id = imageID {
            cell.photoImageView.image = FileManagerHelper.instance.getImageFromStorage(imageName: id)
            self.images.append(cell.photoImageView.image!)
        } else {
            cell.photoImageView.image = UIImage(systemName: "photo.fill")
            self.images.append(UIImage(systemName: "photo.fill")!)
        }
        
        if indexPath.row == directionArray.count - 1 {
            isFirstTime = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToPhotoDetailStoryboard(indexPath: indexPath)
    }
    
}

extension FolderViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 60) / 2
        return CGSize(width: size, height: size + 17)
    }
}
