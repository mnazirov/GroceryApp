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
    
    // MARK: - Products lists methods
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
    
    func delete(productList: ProductList) {
        write {
            let products = productList.products
            realm.delete(products)
            realm.delete(productList)
        }
    }
    
    func done(productList: ProductList) {
        write {
            productList.products.setValue(true, forKey: "isComplete")
        }
    }
    
    // MARK: - Products methods
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
    
    func delete(product: Product) {
        write {
            realm.delete(product)
        }
    }
    
    func done(product: Product) {
        write {
            product.isComplete.toggle()
        }
    }
    
    // MARK: - Private methods
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
