//
//  Extension + UITableViewCell.swift
//  GroceryApp
//
//  Created by Marat on 11.04.2021.
//

import UIKit

extension UITableViewCell {
    func configuration(productList: ProductList) {
        let productsNeedToBuy = productList.products.filter("isComplete = false")
        let productsPurchased = productList.products.filter("isComplete = true")

        var content = defaultContentConfiguration()
        content.text = productList.name
        
        if !productsNeedToBuy.isEmpty {
            content.secondaryText = "\(productsNeedToBuy.count)"
            accessoryType = .none
        } else if !productsPurchased.isEmpty {
            accessoryType = .checkmark
        } else {
            content.secondaryText = "0"
            accessoryType = .none
        }
        
        contentConfiguration = content
    }
}
