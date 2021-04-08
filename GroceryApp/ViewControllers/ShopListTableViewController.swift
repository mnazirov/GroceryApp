//
//  ShopListTableViewController.swift
//  GroceryApp
//
//  Created by Marat on 07.04.2021.
//

import UIKit

class ShopListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        return cell
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
