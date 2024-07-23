//
//  FoodPieChartViewController.swift
//  Final-App
//
//  Created by Roro on 8/6/2024.
//
import Charts
import UIKit
import SwiftUI




class FoodPieChartViewController: UIViewController {
    var currentFood: Food?
    var data: [FoodDataStructure] = []
    
    // Sets the data of the piechart based on the current food, mg is divided by 1000 as 1000mg = 1 g
    func set_data(food:Food) -> [FoodDataStructure]{
        var newData: [FoodDataStructure] = []
        
        newData.append(FoodDataStructure(name: "total carbohydrates", value: food.carbohydrates_total_g))
        newData.append(FoodDataStructure(name: "sodium", value: food.sodium_mg/1000))
        newData.append(FoodDataStructure(name: "potassium", value: food.potassium_mg/1000))
        newData.append(FoodDataStructure(name: "total fat", value: food.fat_total_g))
        newData.append(FoodDataStructure(name: "saturated fat", value: food.fat_saturated_g))
        newData.append(FoodDataStructure(name: "protein", value: food.protein_g))
        newData.append(FoodDataStructure(name: "fiber", value: food.fiber_g))
        newData.append(FoodDataStructure(name: "sugar", value: food.sugar_g))
        newData.append(FoodDataStructure(name: "cholesterol", value: food.cholesterol_mg/1000))
        
        return newData
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let myFood = self.currentFood{
            self.data = self.set_data(food: myFood) // sets the data based on food data
        }
        
        var rootView = ChartUIView(data: self.data) // sets the chart data
        
        
        
        let controller = UIHostingController(rootView: ChartUIView(data: self.data))
        
        guard let chartView = controller.view else {
            return
        }
        view.addSubview(chartView)
        addChild(controller)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 12.0),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -12.0),
            chartView.topAnchor.constraint(equalTo:
                                            view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            chartView.widthAnchor.constraint(equalTo: chartView.heightAnchor)
        ])        // Do any additional setup after loading the view.
    }
    



}
