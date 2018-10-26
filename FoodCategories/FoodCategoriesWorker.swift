//
//  FoodCategoriesWorker.swift
//  FoodCategories
//
//  Created by DEEP PRADHAN on 23/09/18.
//  Copyright © 2018 DEEP PRADHAN. All rights reserved.
//

import Foundation

enum FetchDataResult<U> {
    case success(result: U)
    case failure(error: FetchDataError)
}

enum FetchDataError {
    case cannotFetch(String)
}

class FoodCategoriesWorker {
    var fromStaticJson = true
    
    func fetchFoodVariants(completionHandler: @escaping (_ result: FetchDataResult<[String: Any]>) -> Void) {
        fromStaticJson ? fetchFoodVariantsFromJson(completionHandler: completionHandler): fetchFoodVariantsFromApi()
    }
    
    private func fetchFoodVariantsFromJson(completionHandler: @escaping (_ result: FetchDataResult<[String: Any]>) -> Void) {
        guard let path = Bundle.main.path(forResource: "FoodVariants", ofType: "json") else {
            return
        }
        
        do {
            let data = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
            do {
                let json: [String: Any] = try JSONSerialization.jsonObject(with: data as Data,
                                                                           options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                print(json)
                if let variations = json["variants"] as? [String: Any], let variantsGroups =  variations["variant_groups"] as? [Any], let exlusionGroups =  variations["exclude_list"] as? [Any] {
                    let exlusionList = parseExclusionGroups(groups: exlusionGroups)
                    let variationsGroups = parseVariantsGroups(groups: variantsGroups)
                    completionHandler(FetchDataResult.success(result: ["response": variationsGroups, "exclusionList": exlusionList]))
                }
               
            } catch {
                completionHandler(FetchDataResult.failure(error: FetchDataError.cannotFetch("Sorry json is wrong")))
            }
            
        } catch {
             completionHandler(FetchDataResult.failure(error: FetchDataError.cannotFetch("Sorry data is wrong")))
        }
    }
    
    private func parseVariantsGroups(groups: [Any]) -> [VariantGroupsName] {
        var variantGroupsArr: [VariantGroupsName] = [ ]
        for (index, _) in groups.enumerated() {
            if let data = groups[index] as? [String: Any], let name = data["name"] as? String, let groupId = data["group_id"] as? String{
                if let variations = data["variations"] as? [Any] {
                    let variations =  parseVariations(variations:  variations)
                    let variantGroupNames = VariantGroupsName.init(name: name,
                                                                   group_id: groupId,
                                                                   variations: variations)
                    variantGroupsArr.append(variantGroupNames)
                }
            }
        }
        return variantGroupsArr
    }
    
    private func parseVariations(variations: [Any]) -> [Variations] {
        var variationsArr: [Variations] = []
        for (index, _) in variations.enumerated() {
            if let data = variations[index] as? [String: Any], let name = data["name"] as? String, let price = data["price"] as? Int, let inStock = data["inStock"] as? Int, let id = data["id"] as? String {
                let variations = Variations(name: name,
                                            price: price,
                                            inStock: inStock,
                                            id: id)
                variationsArr.append(variations)
            }
        }
        return variationsArr
    }
    
    
    private func parseExclusionGroups(groups: [Any]) -> [ExclusionList] {
        var exclusionGroupsArr: [ExclusionList] = [ ]
        for (index, _) in groups.enumerated() {
            if let data = groups[index] as? [Any] {
               let exclusion = parseExclusion(exlusion: data)
               let exclusionList = ExclusionList(exlusion: exclusion)
                exclusionGroupsArr.append(exclusionList)
            }
        }
        return exclusionGroupsArr
    }
    
    private func parseExclusion(exlusion: [Any]) -> [Exclusion] {
        var exclusionArr: [Exclusion] = []
        for (index, _) in exlusion.enumerated() {
            if let data = exlusion[index] as? [String: Any], let group_id = data["group_id"] as? String,
                let variationID = data["variation_id"] as? String  {
                let exclusion = Exclusion(groupID: group_id,
                                         variationID: variationID)
                exclusionArr.append(exclusion)
            }
        }
        return exclusionArr
    }
    
    
    private func fetchFoodVariantsFromApi() {
        
    }
}
