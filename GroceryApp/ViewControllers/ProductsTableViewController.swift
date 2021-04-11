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
    var productsNeedToBuy: Results<Product>!
    var productsPurchased: Results<Product>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = productList.name
        
        productsNeedToBuy = productList.products.filter("isComplete = false")
        productsPurchased = productList.products.filter("isComplete = true")
        
        let addAction = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addProduct))
        
        navigationItem.rightBarButtonItems = [addAction, editButtonItem]
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? productsNeedToBuy.count : productsPurchased.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "You need to buy" : "You bought"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = indexPath.section == 0 ? productsNeedToBuy[indexPath.row] : productsPurchased[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = product.name
        content.secondaryText = "\(product.numberOfItems)"
        
        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let product = indexPath.section == 0 ? productsNeedToBuy[indexPath.row] : productsPurchased[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.shared.delete(product: product)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, isDone) in
            self.showAlert(product: product) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            isDone(true)
        }
        
        let title = indexPath.section == 0 ? "Done" : "Undone"
        
        let doneAction = UIContextualAction(style: .normal, title: title) { (_, _, isDone) in
            StorageManager.shared.done(product: product)
            
            let indexProductsNeedTobuy = IndexPath(row: self.productsNeedToBuy.count - 1, section: 0)
            let indexProductsPurchased = IndexPath(row: self.productsPurchased.count - 1, section: 1)
            
            let oppositeSection = indexPath.section == 0 ? indexProductsPurchased : indexProductsNeedTobuy
            
            tableView.moveRow(at: indexPath, to: oppositeSection)
            isDone(true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
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
                let rowIndex = IndexPath(row: self.productsNeedToBuy.count - 1, section: 0)
                self.tableView.insertRows(at: [rowIndex], with: .automatic)
            }
        }
        
        present(alert, animated: true)
    }
    
    @objc private func addProduct() {
        showAlert()
    }
}
