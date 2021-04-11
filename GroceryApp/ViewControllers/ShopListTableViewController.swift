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
        
        navigationItem.leftBarButtonItem = editButtonItem
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
    
    // MARK: - IBAction
    @IBAction func addList(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    @IBAction func filterSender(_ sender: UISegmentedControl) {
    }
    
    // MARK: - Private Methods
    private func showAlert(productList: ProductList? = nil, completion: (() -> Void)? = nil) {
        let title = productList != nil ? "Edit list" : "Add list"
        let message = productList != nil ? "Please edit a new value" : "Please insert a new value"
        
        let alert = AlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        
        alert.actionForList(productList: productList) { newValue in
            if let productList = productList, let completion = completion {
                StorageManager.shared.edit(newValue: newValue, currentList: productList)
                completion()
            } else {
                StorageManager.shared.save(value: newValue)
                self.tableView.insertRows(at: [IndexPath(row: self.productLists.count - 1,
                                                         section: 0)],
                                          with: .automatic)
            }
        }
        
        present(alert, animated: true)
    }
}
