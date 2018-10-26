//
//  FoodCategoriesViewController.swift
//  FoodCategories
//
//  Created by DEEP PRADHAN on 22/09/18.
//  Copyright © 2018 DEEP PRADHAN. All rights reserved.
//

import UIKit

protocol Categories: class {
    func displayCategories(viewModel: FoodCategoriesModel.FetchVariations.ViewModel)
    func displayMessage(viewModel: FoodCategoriesModel.FetchExcludeList.ViewModel)
}

public class FoodCategories: UIViewController, UITableViewDelegate, UITableViewDataSource, Categories {
    
    @IBOutlet weak var foodCategoriesTableView: UITableView!
    var FoodCategoriesInteractor: FoodCategoriesLogic?
    var foodVariants: [VariantGroupsName] = []
    var userSelected: [[String: String]] = [ ]
    // MARK: Object Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        self.FoodCategoriesInteractor = FoodCategoriesLogic()
        let presenter = FoodCategoriesPresenter()
        self.FoodCategoriesInteractor?.presenter = presenter
        let viewController = self
        presenter.foodCategoriesVC = viewController
    }
    
    // MARK: App Life Cycle.
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        fetchFoodVariants()
        setTableViewDelegates()
        registerCell()
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Set the shadow back to nav bar. nil means default shadow
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    
    private func setTableViewDelegates() {
        foodCategoriesTableView.delegate = self
        foodCategoriesTableView.dataSource = self
    }
    
    private func registerCell() {
        self.foodCategoriesTableView.register(UINib (nibName: "FoodCategoriesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FoodCategories")
        
    }
    
    private func fetchFoodVariants() {
        self.FoodCategoriesInteractor?.fetchVariants()
    }
    
    //MARK: Table View Delegate Methods.
    public func numberOfSections(in tableView: UITableView) -> Int {
        return  self.foodVariants.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section: VariantGroupsName = self.foodVariants[section]
        return section.variations.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.foodCategoriesTableView.dequeueReusableCell(withIdentifier: "FoodCategories") as! FoodCategoriesTableViewCell
        let foodVariantsName = self.foodVariants[indexPath.section]
        let variations = foodVariantsName.variations[indexPath.row]
        cell.configureCell(variation: variations)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodVariantsName = self.foodVariants[indexPath.section]
        let variationsList: Variations = foodVariantsName.variations[indexPath.row]
        let groupID = foodVariantsName.group_id
        let id = variationsList.id
        var dict = [String: String]()
        dict["group_id"] = groupID
        dict["variationId"] = id
        self.userSelected.append(dict)
        if (self.userSelected.count == 2) {
            self.FoodCategoriesInteractor?.checkExclusionList(dict: self.userSelected)
            self.userSelected.removeAll()
        }
        print(self.userSelected)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let foodVariantsName = self.foodVariants[section]
        
        return "\u{2022} \(foodVariantsName.name)"
    }
    
    func displayCategories(viewModel: FoodCategoriesModel.FetchVariations.ViewModel) {
        self.foodVariants = viewModel.variationGroups
        loadFoodVariations()
    }
    
    func displayMessage(viewModel: FoodCategoriesModel.FetchExcludeList.ViewModel) {
        let errorMessage = viewModel.errorMessage
        showAlert(message: errorMessage)
    }
    
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            let vc = UIAlertController(title: "Sorry!", message: message, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func loadFoodVariations() {
        DispatchQueue.main.async {
            self.foodCategoriesTableView.reloadData()
        }
    }
}
