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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.shared.delete(productList: self.productLists[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, isDone) in
            self.showAlert(productList: self.productLists[indexPath.row]) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (_, _, isDone) in
            StorageManager.shared.done(productList: self.productLists[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
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
        productLists = sender.selectedSegmentIndex == 0
            ? productLists.sorted(byKeyPath: "name")
            : productLists.sorted(byKeyPath: "date")
        
        tableView.reloadData()
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
