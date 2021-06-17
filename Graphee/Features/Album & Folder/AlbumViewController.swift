//
//  AlbumViewController.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit
import CoreData

class AlbumViewController: UIViewController {

    @IBOutlet weak var albumTableView: UITableView!
    
    var albumArray = ["Product A", "Product B", "Product C"]
    var arrayFolder: [Folder]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(named: "AccentColor")
        
        view.backgroundColor = UIColor.init(named: "AccentColor")
        
        albumTableView.backgroundColor = UIColor.init(named: "DarkColor")
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "DarkColor")]
        
        albumTableView.dataSource = self
        albumTableView.delegate = self
        
        fetchFolder()
    }
    
    func fetchFolder(){
        arrayFolder = CoreDataService.instance.fetchAllFolders()
        DispatchQueue.main.async {
            self.albumTableView.reloadData()
        }
    }
        
    
    @IBAction func addFolderButton(){
        showAlert()
    }
    func showAlert(){
        let alert = UIAlertController(title: "Create a Folder", message: "To start taking pictures, create a new folder to store it", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "DarkColor")
        alert.view.tintColor = UIColor.init(named: "AccentColor")
        alert.view.layer.cornerRadius = 30
        alert.addTextField(configurationHandler: {action in
            
            //get textfield data
            let textfield = alert.textFields![0]
            
            //create an object named Folder
            let newFolder = Folder(context: self.context)
            //newFolder.name = name

            print("typed")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            print("tapped cancel")
        }))
        present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {action in
            print("tapped save")
        }))
        
    }
    
    func renameAlert(){
        let alert = UIAlertController(title: "Rename Album", message: nil, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "DarkColor")
        alert.view.tintColor = UIColor.init(named: "AccentColor")
        alert.view.layer.cornerRadius = 30
        alert.addTextField(configurationHandler: {action in
            print("typed")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            print("tapped cancel")
        }))
        present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {action in
            print("tapped save")
        }))
        
    }
    
    func deleteAlert(){
        let alert = UIAlertController(title: "Delete Product?", message: "All of the photos inside will be permanently deleted", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.init(named: "DarkColor")
        alert.view.tintColor = UIColor.init(named: "AccentColor")
        alert.view.layer.cornerRadius = 30
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            print("tapped cancel")
        }))
        present(alert, animated: true)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            print("tapped delete")
        }))
        
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

//tableview extensions

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let folderViewController = self.storyboard?.instantiateViewController(identifier: "folder") as! FolderViewController
    //folderViewController.productName = arrayFolder[indexPath.row]
        
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
        cell.folderName.text = arrayFolder?[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 112
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //rename
        
        let rename = UIContextualAction(style: .normal, title: "Rename", handler:{(action, view, completionHandler) in self.renameAlert()
        })
        
        //delete
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler:{(action, view, completionHandler) in self.deleteAlert()
            completionHandler(true)
        })
    
    //swipe
        
    let swipe = UISwipeActionsConfiguration(actions: [delete,rename])
    return swipe
}




}
