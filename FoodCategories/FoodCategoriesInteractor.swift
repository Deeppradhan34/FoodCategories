//
//  FoodCategoriesInteractor.swift
//  FoodCategories
//
//  Created by DEEP PRADHAN on 23/09/18.
//  Copyright © 2018 DEEP PRADHAN. All rights reserved.
//

import Foundation

protocol FoodCategoriesBusinessLogic {
    func fetchVariants()
    func checkExclusionList(dict: [[String: String]])
}

protocol FoodCategoriesDataStore {
    var variantGroup: [VariantGroupsName] { get }
    var exludeList: [ExclusionList] { get }
}

class FoodCategoriesLogic: FoodCategoriesBusinessLogic, FoodCategoriesDataStore {
    var variantGroup: [VariantGroupsName] = []
    var presenter: FoodCategoriesPresentationLogic?
    var exludeList: [ExclusionList] = []
    var data = [String: Any]()
    var worker = FoodCategoriesWorker()
    
    func fetchVariants() {
        self.worker.fetchFoodVariants { [weak self] (result: FetchDataResult) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let fetchedData):
                strongSelf.data = fetchedData
                if let variationsGroups = fetchedData["response"] as? [Any] , let exlusionList = fetchedData["exclusionList"]  {
                    strongSelf.variantGroup = variationsGroups as! [VariantGroupsName]
                    strongSelf.exludeList = exlusionList as! [ExclusionList]
                    let response = FoodCategoriesModel.FetchVariations.Response(variationGroups: strongSelf.variantGroup)
                    strongSelf.presenter?.displayFoodVariations(response: response)
                }
            case .failure(let errorMsg):
                print(errorMsg)
            }
        }
    }
    
    
    func checkExclusionList(dict: [[String: String]])  {
        var userCannotSelect = false
        for (index, _) in self.exludeList.enumerated() {
            let a = self.exludeList[index]
            for (index, _) in a.exlusion.enumerated() {
                let b: Exclusion = a.exlusion[index]
                let exclusionGroupID = b.groupID
                let exclusionVariationID = b.variationID
                if let userSelectedDict = dict[index] as? [String: String], let userSelectedID = userSelectedDict["group_id"]  , let userSelectedGroupID = userSelectedDict["variationId"]  {
                    if (exclusionGroupID == userSelectedID && exclusionVariationID == userSelectedGroupID) {
                        userCannotSelect = true
                    } else {
                        userCannotSelect = false
                        break
                    }
                }
            }
            if (userCannotSelect) {
                print("Show error")
                let response = FoodCategoriesModel.FetchExcludeList.Response(errorMessage: "Sorry! You cannot select this combination")
                presenter?.displayMessage(response: response)
                break
            }
        }
    }
}
