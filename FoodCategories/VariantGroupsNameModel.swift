//
//  VariantGroupsNameModel.swift
//  FoodCategories
//
//  Created by DEEP PRADHAN on 23/09/18.
//  Copyright © 2018 DEEP PRADHAN. All rights reserved.
//

import Foundation

struct VariantGroupsName {
    let name: String
    let group_id: String
    let variations: [Variations]
}

struct Variations {
    let name: String
    let price: Int
    let inStock: Int
    let id: String
}

struct ExclusionList {
    let exlusion: [Exclusion]
    
}

struct Exclusion {
    let groupID: String
    let variationID: String
}
