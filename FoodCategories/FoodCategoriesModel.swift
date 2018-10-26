//
//  FoodCategoriesModel.swift
//  FoodCategories
//
//  Created by DEEP PRADHAN on 23/09/18.
//  Copyright © 2018 DEEP PRADHAN. All rights reserved.
//

import Foundation
enum FoodCategoriesModel {
    struct FetchVariations {
        
        struct Request {
            
        }
        
        struct Response {
            var variationGroups: [VariantGroupsName]
        }
        
        struct ViewModel {
            var variationGroups: [VariantGroupsName]
            var identifier: String
        }
    }
    
    struct FetchExcludeList {
        struct Request {
            
        }
        
        struct Response {
            var errorMessage: String
        }
        
        struct ViewModel {
            var errorMessage: String
        }
    }
}
