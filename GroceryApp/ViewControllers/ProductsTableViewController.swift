//
//  ProductsTableViewController.swift
//  GroceryApp
//
//  Created by Marat on 07.04.2021.
//

import UIKit
import RealmSwift

class ProductsTableViewController: UITableViewController {
    
    var productList: ProductList!
    var productsNeedTobuy: Results<Product>!
    var productsPurchased: Results<Product>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = productList.name
        
        productsNeedTobuy = productList.products.filter("isComplete = false")
        productsPurchased = productList.products.filter("isComplete = true")
        
        let addAction = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addProduct))
        
        navigationItem.rightBarButtonItems = [addAction]
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? productsNeedTobuy.count : productsPurchased.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "You need to buy" : "You bought"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = indexPath.section == 0 ? productsNeedTobuy[indexPath.row] : productsPurchased[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = product.name
        content.secondaryText = "\(product.numberOfItems)"
        
        cell.contentConfiguration = content

        return cell
    }
    
    // MARK: - Private Methods
    private func showAlert(product: Product? = nil, completion: (() -> Void)? = nil) {
        let title = product != nil ? "Edit product" : "Add product"
        let message = product != nil ? "Please edit new values" : "Please insert new values"
        
        let alert = AlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        
        alert.actionForProduct(product: product) { (newProductName, newNumberOfItems) in
            if let product = product, let completion = completion {
                StorageManager.shared.edit(product: product,
                                           newProductName: newProductName,
                                           newNumberOfItems: newNumberOfItems)
                completion()
            } else {
                StorageManager.shared.save(productList: self.productList,
                                           newProductName: newProductName,
                                           newNumberOfItems: newNumberOfItems)
                let rowIndex = IndexPath(row: self.productsNeedTobuy.count - 1, section: 0)
                self.tableView.insertRows(at: [rowIndex], with: .automatic)
            }
        }
        
        present(alert, animated: true)
    }
    
    @objc private func addProduct() {
        showAlert()
    }
}
