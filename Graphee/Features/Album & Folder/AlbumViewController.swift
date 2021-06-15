//
//  AlbumViewController.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var albumTableView: UITableView!
    
    var albumArray = ["Product A", "Product B", "Product C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.backgroundColor = .yellow
        
        view.backgroundColor = .yellow
        
        albumTableView.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
        
        albumTableView.dataSource = self
        albumTableView.delegate = self
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

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let folderViewController = self.storyboard?.instantiateViewController(identifier: "folder") as! FolderViewController
        folderViewController.productName = albumArray[indexPath.row]
        
        self.navigationController?.pushViewController(folderViewController, animated: true)
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = albumTableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.folderName.text = albumArray[indexPath.row]
        
        return cell
    }
    
    
}