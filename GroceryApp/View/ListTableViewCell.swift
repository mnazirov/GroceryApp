//
//  ListTableViewCell.swift
//  GroceryApp
//
//  Created by Marat on 14.04.2021.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var numberOfItemLabel: UILabel!
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configuration(productList: ProductList) {
        let productsNeedToBuy = productList.products.filter("isComplete = false")
        let productsPurchased = productList.products.filter("isComplete = true")

        //var content = defaultContentConfiguration()
        nameLabel.text = productList.name
        dateLabel.text = dateFormatter.string(from: productList.date)
        
        if !productsNeedToBuy.isEmpty {
            numberOfItemLabel.text = "\(productsNeedToBuy.count)"
            accessoryType = .none
            numberOfItemLabel.isHidden = false
        } else if !productsPurchased.isEmpty {
            accessoryType = .checkmark
            numberOfItemLabel.isHidden = true
        } else {
            numberOfItemLabel.text = "0"
            accessoryType = .none
            numberOfItemLabel.isHidden = false
        }
        
        //contentConfiguration = content
    }

}
