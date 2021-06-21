//
//  FolderViewController.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit

enum Mode {
    case unselect
    case selected
}

class FolderViewController: UIViewController {
    
    public var parentFolder: Folder!
    private var directionArray: [Photo?] = [nil, nil, nil, nil, nil]
    private var images = [UIImage]()
    private var cellArray = [FolderCollectionViewCell]()
    private var dictionarySelectedIndexPath: [IndexPath:Bool] = [:]
    
    private var mode: Mode = .unselect {
        didSet {
            switchMode()
        }
    }
    
    private var isFirstTime = true
    
    @IBOutlet weak var folderCollectionView: UICollectionView!
    
    private var modeSelectionButton: UIButton!
    private var deleteButton: UIButton!
    private var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(named: "AccentColor")
        
        folderCollectionView.backgroundColor = UIColor.init(named: "DarkColor")
        
        self.title = parentFolder.name
//        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "DarkColor")]
        setRightBarButton()
        
        fetchPhotos()
        
        folderCollectionView.dataSource = self
        folderCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAction), name: Notification.Name("updateAction"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAction), name: Notification.Name("deleteAction"), object: nil)
        
        setBottomButton()
        
    }
    
    @objc private func updateAction() {
        updateUI()
    }
    
    @objc private func deleteAction() {
        fetchPhotos()
        reloadCollectionView()
    }
    
    private func updateUI() {
        fetchPhotos()
        reloadCollectionView()
    }
    
    public func reloadCollectionView() {
        self.images.removeAll()
        cellArray.removeAll()
        DispatchQueue.main.async {
            self.folderCollectionView.reloadData()
        }
    }
    
    public func fetchPhotos() {
        let photoArray = parentFolder.fetchAllPhotosFromFolder()!
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.largeTitleDisplayMode = .always
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
        
        deleteButton.isHidden = true
        saveButton.isHidden = true
    }
    
    @objc private func deleteButtonTapped() {
        
        let alert = UIAlertController(title: "Delete Photo", message: "Do you really want to delete this photo(s) ?", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "DarkColor")
        alert.view.tintColor = UIColor.init(named: "AccentColor")
        alert.view.layer.cornerRadius = 30
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            for (key, value) in self.dictionarySelectedIndexPath {
                if value {
                    
                    FileManagerHelper.instance.deleteImageInStorage(imageName: (self.directionArray[key.row]?.directory)!)
                    CoreDataService.instance.updatePhotoNilImage(photo: self.directionArray[key.row]!)
                }
            }
            
            self.dictionarySelectedIndexPath.removeAll()
            self.checkSelectedCell()
            
            NotificationCenter.default.post(name: Notification.Name("deleteAction"), object: nil)
            
            self.selectedMode()
            
            for cell in self.cellArray {
                if cell.photoImageView.image != UIImage(named: "add_photo") && cell.photoImageView.image != UIImage(named: "add_photo_dark") {
                    cell.selectedImageView.isHidden = false
                } else {
                    cell.selectedImageView.isHidden = true
                }
            }
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        
        for (key, value) in self.dictionarySelectedIndexPath {
            if value {
                UIImageWriteToSavedPhotosAlbum(cellArray[key.row].photoImageView.image!, nil, nil, nil)
            }
        }
        
        let savedAlert = UIAlertController(title: "Saved", message: "Photos successfully saved", preferredStyle: .alert)
        
        savedAlert.view.backgroundColor = UIColor.init(named: "DarkColor")
        savedAlert.view.tintColor = UIColor.init(named: "AccentColor")
        savedAlert.view.layer.cornerRadius = 30
        savedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in self.unselectMode()}))
        present(savedAlert, animated: true, completion: nil)
        
        print("Success Save")
    }
    
    private func setRightBarButton() {
        modeSelectionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 15))
        modeSelectionButton.backgroundColor = UIColor.init(named: "Title")
        modeSelectionButton.layer.cornerRadius = 15
        modeSelectionButton.setTitle("Select", for: .normal)
        modeSelectionButton.titleLabel?.font = UIFont(name: "Sora-Regular", size: 15)
        modeSelectionButton.setTitleColor(UIColor.init(named: "LightColor"), for: .normal)
        modeSelectionButton.addTarget(self, action: #selector(modeButtonSelector), for: .touchUpInside)
        
        let rightBarItem = UIBarButtonItem(customView: modeSelectionButton)
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc private func modeButtonSelector() {
        mode = (mode == .unselect) ? .selected : .unselect; setCanceledUI()
    }
    
    private func setCanceledUI() {
        dictionarySelectedIndexPath.removeAll()
        
        guard let selectedItems = folderCollectionView.indexPathsForSelectedItems else { return }
        
        for indexPath in selectedItems {
            folderCollectionView.deselectItem(at: indexPath, animated:true)
        }
        
        for cell in cellArray {
            cell.selectedImageView.image = UIImage(systemName: "circle")
        }
    }
    
    private func switchMode() {
        switch mode {
            case .unselect:
                unselectMode()
            case .selected:
                selectedMode()
        }
    }
    
    private func unselectMode() {
        modeSelectionButton.setTitle("Select", for: .normal)
        folderCollectionView.allowsMultipleSelection = false
        deleteButton.isHidden = true
        saveButton.isHidden = true
        
        for cell in cellArray {
            cell.selectedImageView.isHidden = true
        }
    }
    
    private func selectedMode() {
        modeSelectionButton.setTitle("Cancel", for: .normal)
        folderCollectionView.allowsMultipleSelection = true
        
        for cell in cellArray {
            if cell.photoImageView.image != UIImage(named: "add_photo") && cell.photoImageView.image != UIImage(named: "add_photo_dark") {
                cell.selectedImageView.isHidden = false
            }
        }
    }

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
            cell.photoImageView.contentMode = .scaleAspectFill
            self.images.append(cell.photoImageView.image!)
            
            if mode == .selected {
                cell.selectedImageView.isHidden = false
            }
        } else {
            cell.photoImageView.image = returnLightOrDarkImage()
            cell.photoImageView.contentMode = .scaleAspectFit
            self.images.append(cell.photoImageView.image!)
            cell.selectedImageView.isHidden = true
        }
        
        cell.selectedImageView.image = UIImage(systemName: "circle")
        
        if indexPath.row == directionArray.count - 1 {
            isFirstTime = false
        }
        
        cellArray.append(cell)
        return cell
    }
    
    private func returnLightOrDarkImage() -> UIImage {
        switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    return UIImage(named: "add_photo")!
                case .dark:
                    return UIImage(named: "add_photo_dark")!
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch mode {
        case .unselect:
            navigateToPhotoDetailStoryboard(indexPath: indexPath)
            break
        case .selected:
            didSelectedCellMode(indexPath: indexPath)
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        didDeselectedCellMode(indexPath: indexPath)
        
    }
    
    private func didSelectedCellMode(indexPath: IndexPath) {
        if cellArray[indexPath.row].photoImageView.image != UIImage(named: "add_photo_dark") && cellArray[indexPath.row].photoImageView.image != UIImage(named: "add_photo") {
            dictionarySelectedIndexPath[indexPath] = true
            cellArray[indexPath.row].selectedImageView.image = UIImage(systemName: "checkmark.circle.fill")
            deleteButton.isHidden = false
            saveButton.isHidden = false
        }
    }
    
    private func didDeselectedCellMode(indexPath: IndexPath) {
        if mode == .selected {
            if cellArray[indexPath.row].photoImageView.image != UIImage(named: "add_photo_dark") && cellArray[indexPath.row].photoImageView.image != UIImage(named: "add_photo") {
                dictionarySelectedIndexPath[indexPath] = false
                cellArray[indexPath.row].selectedImageView.image = UIImage(systemName: "circle")
                
                checkSelectedCell()
            }
            
        }
        
    }
    
    private func checkSelectedCell() {
        var check = false
        for value in dictionarySelectedIndexPath.values {
            if value {
                check = true
                break
            }
        }
        
        if check == false {
            deleteButton.isHidden = true
            saveButton.isHidden = true
        }
    }
}

extension FolderViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 60) / 2
        return CGSize(width: size, height: size + 17)
    }
}
