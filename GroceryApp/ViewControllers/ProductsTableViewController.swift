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
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? productsNeedTobuy.count : productsPurchased.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Need to buy" : "Purchased"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = indexPath.section == 0 ? productsNeedTobuy[indexPath.row] : productsPurchased[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = product.name
        content.secondaryText = product.descr
        
        cell.contentConfiguration = content

        return cell
    }
}
