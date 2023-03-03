//
//  Nutrition.swift
//  Nutrition App
//
//  Created by Paul McSlarrow on 2/24/23.
//

import Foundation
import HealthKit


func nutritionQuery(queryString:String, healthStore: HKHealthStore) {
    let query = "1lb brisket and fries".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string: "https://api.api-ninjas.com/v1/nutrition?query="+query!)!
    var request = URLRequest(url: url)
    request.setValue("eJAM7Fky0cemG6/Kf7Bd1A==drviRVkFJsIN2QDy", forHTTPHeaderField: "X-Api-Key")

    let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        guard let data = data else { return }
        let jsonString = String(data: data, encoding: .utf8)!
        if let jsonData = jsonString.data(using: .utf8),
           let jsonArray = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String:Any]] {
            let filteredArray = jsonArray.map { dict in
                return ["name": dict["name"] as? String ?? "",
                        "calories": dict["calories"] as? Double ?? 0.0,
                        "serving_size_g": dict["serving_size_g"] as? Double ?? 0.0]
            }
            var calories = 0.0
            for i in filteredArray.indices {
                let curr = filteredArray[i]
                calories += curr["calories"] as! Double
            }
            print(calories)
            updateDietaryEnergyConsumed(calories: calories, healthStore: healthStore)
            
        }
    }
    task.resume()
}

func updateDietaryEnergyConsumed(calories: Double, healthStore:HKHealthStore) {
    guard let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
        print("Dietary energy consumed type is no longer available in HealthKit.")
        return
    }
    
    let unit = HKUnit.kilocalorie()
    let quantity = HKQuantity(unit: unit, doubleValue: calories)
    let now = Date()
    let sample = HKQuantitySample(type: dietaryEnergyConsumedType, quantity: quantity, start: now, end: now)
    
    healthStore.save(sample) { success, error in
        if let error = error {
            print("Error saving dietary energy consumed sample: \(error.localizedDescription)")
        } else {
            print("Dietary energy consumed sample saved successfully.")
        }
    }
}

