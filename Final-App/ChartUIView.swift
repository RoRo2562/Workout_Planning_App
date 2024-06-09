//
//  ChartUIView.swift
//  Final-App
//
//  Created by Roro on 8/6/2024.
//

import SwiftUI
import Charts


struct FoodDataStructure: Identifiable {
    
    var name: String
    var value: Float
    var id = UUID()
}


struct ChartUIView: View {
    var data: [FoodDataStructure] = [
        FoodDataStructure(name: "protein", value: 100.0)
    ]
    
    init(data: [FoodDataStructure]) {
        self.data = data
    }
    
    

    
    var body: some View {
        Chart{
            ForEach(data){ d in
                SectorMark(angle: .value("value", d.value),
                           angularInset: 1)
                    .foregroundStyle(by: .value("macro", d.name))
            }
        }
    }
}


