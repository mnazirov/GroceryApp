//
//  StorageManager.swift
//  GroceryApp
//
//  Created by Marat on 08.04.2021.
//

import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    // MARK: - Methods for product list
    func save(value: String) {
        let productList = ProductList()
        productList.name = value
        
        write {
            realm.add(productList)
        }
    }
    
    func edit(newValue: String, currentList: ProductList) {
        write {
            currentList.name = newValue
        }
    }
    
    // MARK: - Methods for products
    func save(productList: ProductList, newProductName: String, newNumberOfItems: String) {
        let product = Product()
        product.name = newProductName
        product.numberOfItems = Int(newNumberOfItems) ?? 0
        
        write {
            productList.products.append(product)
        }
    }
    
    func edit(product: Product, newProductName: String, newNumberOfItems: String) {
        write {
            product.name = newProductName
            product.numberOfItems = Int(newNumberOfItems) ?? 0
        }
    }
    
    private func write(_ completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch let error {
            print(error)
        }
    }
    
    private init() {}
}
