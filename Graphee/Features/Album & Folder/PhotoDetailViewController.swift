//
//  PhotoDetailViewController.swift
//  Graphee
//
//  Created by Luis Genesius on 18/06/21.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    public var parentFolder: Folder!
    public var directionArray: [Photo?]!
    public var imageArray = [UIImage]()
    
    private var isFirstTime = true
    
    public var  initialIndexPath = IndexPath()
    private var insideIndexPath = IndexPath()
    private var firstTime = true

    private var isInitialized = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setRightBarButton()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        DispatchQueue.main.async {
            self.photoCollectionView.scrollToItem(at: self.initialIndexPath, at: .centeredHorizontally, animated: false)
        }
        
        insideIndexPath = initialIndexPath
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAction), name: Notification.Name("updateAction"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
    }
    
    @objc private func updateAction() {
        updateUI()
    }
    
    private func updateUI() {
        fetchPhotos()
        reloadCollectionView()
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData()
        }
    }
    
    private func fetchPhotos() {
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
    }
    
    private func setRightBarButton() {
        
        let button1 = UIBarButtonItem(title: "Retake", style: .plain, target: self, action: #selector(retakeSelector))
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    @objc private func retakeSelector() {
        CameraImages.shared.setNextDirection(direction: (self.directionArray[self.insideIndexPath.row]?.direction)!)
        
        for photo in directionArray {
            if photo?.direction == Direction.front.rawValue {
                if imageArray[0] == UIImage(systemName: "photo.fill") {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: nil)
                } else {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: imageArray[0])
                }
                
            } else if photo?.direction == Direction.back.rawValue {
                if imageArray[1] == UIImage(systemName: "photo.fill") {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: nil)
                } else {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: imageArray[1])
                }
            } else if photo?.direction == Direction.right.rawValue {
                if imageArray[2] == UIImage(systemName: "photo.fill") {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: nil)
                } else {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: imageArray[2])
                }
            } else if photo?.direction == Direction.left.rawValue {
                if imageArray[3] == UIImage(systemName: "photo.fill") {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: nil)
                } else {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: imageArray[3])
                }
            } else if photo?.direction == Direction.detail.rawValue {
                if imageArray[4] == UIImage(systemName: "photo.fill") {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: nil)
                } else {
                    CameraImages.shared.addImage(direction: (photo?.direction)!, image: imageArray[4])
                }
            }
        }
        
        self.navigateToMainCameraStoryboard()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func navigateToMainCameraStoryboard() {
        let mainCameraStoryboard = UIStoryboard(name: "MainCameraStoryboard", bundle: nil)
        let mainCameraViewController = mainCameraStoryboard.instantiateViewController(identifier: "mainCameraStoryboard") as! MainCameraViewController
        
        mainCameraViewController.directionArray = self.directionArray
        
        self.navigationController?.pushViewController(mainCameraViewController, animated: true)
    }

}

extension PhotoDetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard var centreCell = self.photoCollectionView.visibleCells.first else {return}
        let collectionViewCentre = photoCollectionView.bounds.size.width / 2.0
        for cell in photoCollectionView.visibleCells {
            let offset = photoCollectionView.contentOffset.x
            let closestCellDelta = abs(centreCell.center.x - collectionViewCentre - offset)
            let cellDelta = abs(cell.center.x - collectionViewCentre - offset)
            if (cellDelta < closestCellDelta){
                centreCell = cell
            }
        }
        
        let centreIndexPath = self.photoCollectionView.indexPath(for: centreCell)!
        
        if firstTime == true {
            firstTime = false
        } else {
            insideIndexPath = centreIndexPath
            self.title = directionArray[centreIndexPath.row]?.direction
        }
    }
}

extension PhotoDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoDetailCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.photoImageView.widthAnchor.constraint(equalToConstant: photoCollectionView.frame.size.width).isActive = true
        cell.photoImageView.heightAnchor.constraint(equalToConstant: photoCollectionView.frame.size.height).isActive = true
        
        if isFirstTime {
            cell.photoImageView.image = imageArray[indexPath.row]
        } else {
            let imageID = directionArray[indexPath.row]?.directory
            if let id = imageID {
                cell.photoImageView.image = FileManagerHelper.instance.getImageFromStorage(imageName: id)
            } else {
                cell.photoImageView.image = UIImage(systemName: "photo.fill")
            }
        }
        
        if indexPath.row == directionArray.count - 1 {
            isFirstTime = false
        }
        
        return cell
    }
    
    
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frame = photoCollectionView.frame

        return CGSize(width: frame.size.width, height: frame.size.height)
    }
    
}
