//
//  HealthKitManager.swift
//  Final-App
//
//  Created by Roro on 21/5/2024.
//

import Foundation
import HealthKit
import WidgetKit

class HealthKitManager: ObservableObject{
    static let shared = HealthKitManager()

     var healthStore = HKHealthStore()

     var stepCountToday: Int = 0
     var thisWeekSteps: [Int: Int] = [1: 0, 2: 0, 3: 0,
                                      4: 0, 5: 0, 6: 0, 7: 0]
   
}
