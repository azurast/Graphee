//
//  PhotoDetailViewController.swift
//  Graphee
//
//  Created by Luis Genesius on 18/06/21.
//

import UIKit
import AVFoundation

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    public var parentFolder: Folder!
    public var directionArray: [Photo?]!
    public var imageArray = [UIImage]()
    
    private var isFirstTime = true
    
    public var  initialIndexPath = IndexPath()
    private var insideIndexPath = IndexPath()
    private var firstTime = true

    private var isInitialized = true
    
    private var deleteButton: UIButton!
    private var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        takePhotoButton.layer.cornerRadius = 10
        setRightBarButton()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        view.backgroundColor = UIColor.init(named: "Title")
        photoCollectionView.backgroundColor = UIColor.init(named: "DarkColor")
        
        DispatchQueue.main.async {
            self.photoCollectionView.scrollToItem(at: self.initialIndexPath, at: .centeredHorizontally, animated: false)
            self.pageControl.currentPage = self.initialIndexPath.row
        }
        
        insideIndexPath = initialIndexPath
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAction), name: Notification.Name("updateAction"), object: nil)
        
        setBottomButton()
        enableDisableRetake()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(named: "Title")
        self.navigationController?.navigationBar.tintColor = UIColor.init(named: "LightColor")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
        self.navigationController?.navigationBar.tintColor = UIColor.init(named: "Title")
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(named: "AccentColor")
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    @objc private func updateAction() {
        updateUI()
    }
    
    private func updateUI() {
        fetchPhotos()
        reloadCollectionView()
        enableDisableRetake()
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.photoCollectionView.reloadData()
        }
    }
    
    private func enableDisableRetake() {
        if directionArray?[insideIndexPath.row]?.directory == nil {
            disableRightBarButton()
        } else {
            enableRightBarButton()
        }
    }
    
    private func enableRightBarButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.tintColor = nil
        takePhotoButton.isHidden = true
        deleteButton.isHidden = false
        saveButton.isHidden = false
    }
    
    private func disableRightBarButton() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = .clear
        takePhotoButton.isHidden = false
        deleteButton.isHidden = true
        saveButton.isHidden = true
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
        capturePhotoButtonNavigation()
    }
    
    @IBAction func takeButtonTapped(sender: UIButton) {
        capturePhotoButtonNavigation()
    }
    
    private func capturePhotoButtonNavigation() {
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                guard granted else {
                    self.giveAlertOpenSettings()
                    return
                }
                
                self.configureBeforeGoToNextPage()
            }
        }
        
    }
    
    private func giveAlertOpenSettings() {
        let alert = UIAlertController(title: "No Permission", message: "To access camera, you have to give permission", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Open Setting", style: .default, handler: { action in
            let settingURLString = UIApplication.openSettingsURLString
            if let settingsURL = URL(string: settingURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func configureBeforeGoToNextPage() {
        CameraImages.shared.setNextDirection(direction: (self.directionArray[self.insideIndexPath.row]?.direction)!)
        
        for photo in directionArray {
            
            if photo?.directory == nil {
                CameraImages.shared.addImage(direction: (photo?.direction)!, image: nil)
            } else {
                CameraImages.shared.addImage(direction: (photo?.direction)!, image: FileManagerHelper.instance.getImageFromStorage(imageName: (photo?.directory)!))
                
                let image = CameraImages.shared.returnImageFromDirection(direction: photo!.direction!)
                let result = (image?.size.height)! / (image?.size.width)!
                
                if result < 1.1 {
                    CameraImages.shared.addRatio(direction: photo!.direction!, ratio: SettingHelper.shared.ratio11)
                } else if result >= 1.1 && result < 1.6 {
                    CameraImages.shared.addRatio(direction: photo!.direction!, ratio: SettingHelper.shared.ratio43)
                } else {
                    CameraImages.shared.addRatio(direction: photo!.direction!, ratio: SettingHelper.shared.ratio169)
                }
            }
        }
        
        self.navigateToMainCameraStoryboard()
    }
    
    private func setBottomButton() {
        deleteButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 60, width: 30, height: 30))
        deleteButton.setBackgroundImage(UIImage(systemName: "trash.fill"), for: .normal)
        deleteButton.tintColor = UIColor.init(named: "AccentColor")
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        view.addSubview(deleteButton)
        
        saveButton = UIButton(frame: CGRect(x: view.frame.width - 50, y: view.frame.height - 60, width: 30, height: 30))
        saveButton.setBackgroundImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        saveButton.tintColor = UIColor.init(named: "AccentColor")
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    @objc private func saveButtonTapped() {
        let image = FileManagerHelper.instance.getImageFromStorage(imageName: (self.directionArray![insideIndexPath.row]?.directory)!)
        
        guard let currentImage = image else { return }
        
        UIImageWriteToSavedPhotosAlbum(currentImage, nil, nil, nil)
        
        let savedAlert = UIAlertController(title: "Saved", message: "Photo successfully saved", preferredStyle: .alert)
        
        savedAlert.view.backgroundColor = UIColor.init(named: "DarkColor")
        savedAlert.view.tintColor = UIColor.init(named: "AccentColor")
        savedAlert.view.layer.cornerRadius = 30
        present(savedAlert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1.75
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            savedAlert.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(title: "Delete Photo", message: "Do you really want to delete this photo ?", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "DarkColor")
        alert.view.tintColor = UIColor.init(named: "AccentColor")
        alert.view.layer.cornerRadius = 30
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            FileManagerHelper.instance.deleteImageInStorage(imageName: (self.directionArray[self.insideIndexPath.row]?.directory)!)
            CoreDataService.instance.updatePhotoNilImage(photo: self.directionArray[self.insideIndexPath.row]!)
            
            self.updateUI()
            
            NotificationCenter.default.post(name: Notification.Name("deleteAction"), object: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
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
            enableDisableRetake()
        }
        
        pageControl.currentPage = centreIndexPath.row
    }
}

extension PhotoDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoDetailCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        if isFirstTime {
            cell.photoImageView.widthAnchor.constraint(equalToConstant: photoCollectionView.frame.size.width).isActive = true
            cell.photoImageView.heightAnchor.constraint(equalToConstant: photoCollectionView.frame.size.height).isActive = true
        }
        
        let imageID = directionArray[indexPath.row]?.directory
        if let id = imageID {
            cell.photoImageView.image = FileManagerHelper.instance.getImageFromStorage(imageName: id)
        } else {
            cell.photoImageView.image = UIImage.init(named: "no_photo_light")!
        }
        
        cell.photoImageView.contentMode = .scaleAspectFit
        
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
