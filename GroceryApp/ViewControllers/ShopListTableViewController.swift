//
//  ShopListTableViewController.swift
//  GroceryApp
//
//  Created by Marat on 07.04.2021.
//

import UIKit
import RealmSwift

class ShopListTableViewController: UITableViewController {
    
    private var productLists: Results<ProductList>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productLists = StorageManager.shared.realm.objects(ProductList.self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let productList = productLists[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = productList.name
        content.secondaryText = "\(productList.products.count)"
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let productsVC = segue.destination as? ProductsTableViewController else { return }

        let productList = productLists[indexPath.row]
        
        productsVC.productList = productList
    }
    
    @IBAction func addList(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    @IBAction func filterSender(_ sender: UISegmentedControl) {
    }
    
    // MARK: - Private Methods
    private func showAlert(task: ProductList? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Edit list" : "Add list"
        let message = task != nil ? "Please edit a new value" : "Please insert a new value"
        
        let alert = AlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        
        alert.action(productList: task) { newValue in
            
            print(newValue)
        }
        
        present(alert, animated: true)
    }
}
