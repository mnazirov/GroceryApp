//
//  AlertController.swift
//  GroceryApp
//
//  Created by Marat on 08.04.2021.
//

import UIKit

class AlertController: UIAlertController {
    func actionForList(productList: ProductList? = nil, completion: @escaping (String) -> Void) {
        let doneText = productList != nil ? "Update" : "Save"
        
        let saveAction = UIAlertAction(title: doneText,
                                       style: .default) { _ in
            guard let newListName = self.textFields?.first?.text else { return }
            guard !newListName.isEmpty else { return }
            completion(newListName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.text = productList?.name
            textField.placeholder = "List name"
        }
    }
    
    func actionForProduct(product: Product? = nil, completion: @escaping (String, String) -> Void) {
        let doneText = product != nil ? "Update" : "Save"
        
        let saveAction = UIAlertAction(title: doneText,
                                       style: .default) { _ in
            guard let newProductName = self.textFields?.first?.text else { return }
            guard var newNumberOfItems = self.textFields?.last?.text else { return }
            guard !newProductName.isEmpty else { return }
            
            if newNumberOfItems.isEmpty {
                newNumberOfItems = "1"
            }
            
            completion(newProductName, newNumberOfItems)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.text = product?.name
            textField.placeholder = "List name"
        }
        addTextField { textField in
            if let product = product {
                textField.text = "\(product.numberOfItems)"
            }
            textField.placeholder = "Number of item"
        }
    }
}
