//
//  FoodCategoriesPresenter.swift
//  FoodCategories
//
//  Created by DEEP PRADHAN on 23/09/18.
//  Copyright © 2018 DEEP PRADHAN. All rights reserved.
//

import Foundation

protocol FoodCategoriesPresentationLogic {
    func displayFoodVariations(response: FoodCategoriesModel.FetchVariations.Response)
    func displayMessage(response: FoodCategoriesModel.FetchExcludeList.Response)
}

class FoodCategoriesPresenter: FoodCategoriesPresentationLogic {
    weak var foodCategoriesVC: Categories?
    func displayMessage(response: FoodCategoriesModel.FetchExcludeList.Response) {
        let viewModel = FoodCategoriesModel.FetchExcludeList.ViewModel(errorMessage: response.errorMessage)
        foodCategoriesVC?.displayMessage(viewModel: viewModel)
        
    }
    
    func displayFoodVariations(response: FoodCategoriesModel.FetchVariations.Response) {
        let viewModel = FoodCategoriesModel.FetchVariations.ViewModel(variationGroups: response.variationGroups, identifier: "")
        foodCategoriesVC?.displayCategories(viewModel: viewModel)
    }
    
}
