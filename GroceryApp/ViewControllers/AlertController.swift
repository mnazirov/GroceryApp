//
//  AlertController.swift
//  GroceryApp
//
//  Created by Marat on 08.04.2021.
//

import UIKit

class AlertController: UIAlertController {
    func action(productList: ProductList? = nil, completion: @escaping (String) -> Void) {
        let saveText = productList != nil ? "Update" : "Save"
        
        let saveAction = UIAlertAction(title: saveText,
                                       style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.text = productList?.name
            textField.placeholder = "List name"
        }
    }
}
