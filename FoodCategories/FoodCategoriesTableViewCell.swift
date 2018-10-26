//
//  FoodCategoriesTableViewCell.swift
//  FoodCategories
//
//  Created by DEEP PRADHAN on 22/09/18.
//  Copyright © 2018 DEEP PRADHAN. All rights reserved.
//

import Foundation
import UIKit


public class FoodCategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var variationNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var inStockLabel: UILabel!
    
    
    internal func configureCell(variation: Variations) {
        self.variationNameLabel.text = variation.name
        let priceStr = String(variation.price)
        self.priceLabel.text = priceStr
        if variation.inStock == 1 {
         self.inStockLabel.text = "YES"
        }
    }
}

