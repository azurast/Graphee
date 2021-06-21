//
//  AlbumViewController.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit
import CoreData

class AlbumViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var albumTableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var backgroundImage: UIImageView!

    // MARK: - Attributes
    private var arrayFolder: [Folder]?
    private var indexPathOfAlbum: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationView()
        
        
        view.backgroundColor = UIColor.init(named: "AccentColor")
        albumTableView.backgroundColor = UIColor.init(named: "DarkColor")
        
        albumTableView.dataSource = self
        albumTableView.delegate = self
        
        fetchFolder()
        setupBackgroundImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAction), name: Notification.Name("updateAction"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAction), name: Notification.Name("deleteAction"), object: nil)
    }
    
    @objc private func updateAction() {
        fetchFolder()
    }
    
    @objc private func deleteAction() {
        fetchFolder()
    }
    
    private func setupBackgroundImage() {
        if arrayFolder?.count == 0 {
            stackView.isHidden = false
            backgroundImage.image = UIImage.init(named: "folder_background")
        } else {
            stackView.isHidden = true
        }
    }
    
    private func setUpNavigationView(){
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(named: "AccentColor")
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "Title")!, NSAttributedString.Key.font: UIFont(name: "Sora-SemiBold", size: 32)!]
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 30)
        menuBtn.setBackgroundImage(UIImage(systemName: "folder.fill.badge.plus"), for: .normal)
        menuBtn.addTarget(self, action: #selector(addFolder), for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    private func fetchFolder(){
        arrayFolder = CoreDataService.instance.fetchAllFolders()
        
        setupBackgroundImage()
        
        DispatchQueue.main.async {
            self.albumTableView.reloadData()
        }
    }
    
    @objc func addFolder() {
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Create a Folder", message: "To start taking pictures, create a new folder to store it", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "DarkColor")
        alert.view.tintColor = UIColor.init(named: "AccentColor")
        alert.view.layer.cornerRadius = 30
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            print("tapped cancel")
        }))
        present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            
            guard let text = alert.textFields?[0].text else { return }
            
            if text == "" {
                return
            }
            
            CoreDataService.instance.saveFolder(name: text)
            
            self.fetchFolder()
        }))
        
    }
    
    private func renameAlert() {
        let alert = UIAlertController(title: "Rename Album", message: nil, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "DarkColor")
        alert.view.tintColor = UIColor.init(named: "AccentColor")
        alert.view.layer.cornerRadius = 30
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            print("tapped cancel")
        }))
        present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {action in
            guard let text = alert.textFields?[0].text else { return }
            
            if text == "" {
                return
            }
            
            guard let indexPath = self.indexPathOfAlbum else { return }
            
            guard let wantUpdateFolder = self.arrayFolder?[indexPath.row] else { return }
            
            CoreDataService.instance.updateFolder(folder: wantUpdateFolder, name: text)
            
            self.indexPathOfAlbum = nil
            
            self.fetchFolder()
        }))
        
    }
    
    private func deleteAlert() {
        let alert = UIAlertController(title: "Delete Product?", message: "All of the photos inside will be permanently deleted", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "DarkColor")
        alert.view.tintColor = UIColor.init(named: "AccentColor")
        alert.view.layer.cornerRadius = 30
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            guard let indexPath = self.indexPathOfAlbum else { return }
            
            guard let wantDeleteFolder = self.arrayFolder?[indexPath.row] else { return }
            
            CoreDataService.instance.deleteFolder(folder: wantDeleteFolder)
            
            self.indexPathOfAlbum = nil
            
            self.fetchFolder()
        }))
        
    }

}

//tableview extensions

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let folderViewController = self.storyboard?.instantiateViewController(identifier: "folder") as! FolderViewController
        folderViewController.parentFolder = arrayFolder![indexPath.row]
        
        self.navigationController?.pushViewController(folderViewController, animated: true)
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFolder?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = albumTableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        cell.folderFirstImage.layer.cornerRadius = 10
        
        cell.folderName.text = arrayFolder?[indexPath.row].name
        
        let imageID = arrayFolder?[indexPath.row].fetchFirstImageFromChild()
        if let id = imageID {
            cell.folderFirstImage.image = FileManagerHelper.instance.getImageFromStorage(imageName: id)
        } else {
            cell.folderFirstImage.image = UIImage(systemName: "photo.fill")
        }
        
        cell.folderStatus.text = "\(arrayFolder![indexPath.row].fetchPhotosStatus()) of 5 Completed"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 112
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //rename
        
        let rename = UIContextualAction(style: .normal, title: "Rename", handler:{(action, view, completionHandler) in
            
            self.indexPathOfAlbum = indexPath
            self.renameAlert()
            completionHandler(true)
        })
        
        //delete
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler:{(action, view, completionHandler) in
            
            self.indexPathOfAlbum = indexPath
            self.deleteAlert()
            completionHandler(true)
        })
    
    //swipe
        
    let swipe = UISwipeActionsConfiguration(actions: [delete,rename])
    return swipe
}
}
