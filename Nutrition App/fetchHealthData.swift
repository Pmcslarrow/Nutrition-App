//
//  fetchHealthData.swift
//  Nutrition App
//
//  Created by Paul McSlarrow on 2/13/23.
//

import Foundation
import SwiftUI
import HealthKit


struct CustomColor {
    static let myDarkGreen = Color("myDarkGreen")
    static let myGray = Color("myGray")
    static let myLightGray = Color("myLightGray")
    static let myLightGreen = Color("myLightGreen")
    static let myPlatinum = Color("myPlatinum")
    static let myBackground = Color("myBackground")
}

// Model
struct HealthObject {
    var isAuthorized = false
    var HEIGHT: Double = 0.0
    var BODY_MASS: Double = 0.0
    var BODY_MASS_KG: Double = 0.0
    var DIETARY_WATER: Double = 0.0
    var STEP_COUNT: Int = 0
    var ACTIVE_ENERGY_BURNED: Double = 0.0
    var BASAL_ENERGY_BURNED: Double = 0.0
    var GENDER: String = "N/A"
    var AGE: String = "N/A"
    var TDEE: Double = 0.0
    var BMR: Double = 0.0
    var CALORIES_EATEN: Double = 0.0
    var CURRENT_GOAL: String = "none"
}

struct Recipe {
    var title: String
    var nCalories: String
    var protein: String
    var fat: String
    var carbs: String
    var url: String
    var image_url: String
}

// ViewModel
class HealthData: ObservableObject {
    
    @Published var model = HealthObject()
    let healthStore = HKHealthStore()
    
    var isAuthorized: Bool {
        model.isAuthorized
    }
    
    var HEIGHT: Double {
        model.HEIGHT
    }
    
    var BODY_MASS: Double {
        model.BODY_MASS
    }
    
    var BODY_MASS_KG: Double {
        model.BODY_MASS_KG
    }
    
    var DIETARY_WATER: Double {
        model.DIETARY_WATER
    }
    
    var STEP_COUNT: Int {
        model.STEP_COUNT
    }
    
    var ACTIVE_ENERGY_BURNED: Double {
        model.ACTIVE_ENERGY_BURNED
    }
    
    var BASAL_ENERGY_BURNED: Double {
        model.BASAL_ENERGY_BURNED
    }
    
    var GENDER: String {
        model.GENDER
    }
    
    var AGE: String {
        model.AGE
    }
    
    var BMR: Double {
        model.BMR
    }
    
    var TDEE: Double {
        model.TDEE
    }
    
    var CURRENT_GOAL: String {
        model.CURRENT_GOAL
    }
    
    var CALORIES_EATEN: Double {
        model.CALORIES_EATEN
    }

    var bgColor = Color(.sRGB, red: 0.94, green: 0.54, blue: 0.15)
    
    let list_of_recipes: [Recipe] = [
        Recipe(title: "Honey Garlic Chicken", nCalories: "258", protein: "25", fat: "12", carbs:"18", url:"https://www.delish.com/cooking/recipe-ideas/recipes/a49507/honey-garlic-chicken-recipe/", image_url: "honey_garlic"),
        
        Recipe(title: "One Pot Chicken Alfredo", nCalories: "444", protein: "35", fat: "21", carbs: "43", url: "https://www.eatingwell.com/recipe/275290/one-pot-chicken-alfredo/", image_url: "one_pot_chicken_alfredo"),
        
        Recipe(title: "Salted Peanut Butter Smoothie", nCalories: "854", protein: "22", fat: "9", carbs: "55", url: "https://www.purewow.com/recipes/Salted-Peanut-Butter-Cup-Smoothie", image_url: "salted_pb_smoothie"),
        
        Recipe(title: "Strawberry Protein Shake", nCalories: "309", protein: "21", fat: "7", carbs: "43", url: "https://feelgoodfoodie.net/recipe/organic-strawberry-sweet-vanilla-smoothie/", image_url: "strawberry_protein_shake"),
        
        Recipe(title: "Steak Burrito Bowl", nCalories: "549", protein: "32", fat: "24", carbs: "49", url: "https://www.bbcgoodfood.com/recipes/steak-burrito-bowl", image_url: "steak_burrito_bowl"),
        
        Recipe(title: "Oven Baked Pork Chops", nCalories: "805", protein: "46", fat: "38", carbs: "67", url: "https://www.bbcgoodfood.com/recipes/oven-baked-pork-chops", image_url: "oven_baked_porkchops"),
        
        Recipe(title: "Protein Pancakes", nCalories: "258", protein: "32", fat: "10", carbs: "5", url: "https://healthyrecipesblogs.com/protein-pancakes/", image_url: "protein_pancakes"),
        
        Recipe(title: "Peanut Butter Energy Bites", nCalories: "200", protein: "6", fat: "13", carbs: "16", url: "https://chefsavvy.com/5-ingredient-peanut-butter-energy-bites/", image_url: "pb_protein_balls"),
        
        Recipe(title: "Pulled Pork Sandwich", nCalories: "303", protein: "10", fat: "17", carbs: "29", url: "https://www.kimscravings.com/easy-pulled-pork-sliders/", image_url: "pulled_pork_sandwich"),
        
        Recipe(title: "Baked Salmon", nCalories: "250", protein: "29", fat: "18", carbs: "1", url: "https://www.primaverakitchen.com/garlic-butter-salmon-in-foil-recipe/", image_url: "baked_salmon")
    ]

    func requestAccess() {
        let healthStore = HKHealthStore()
        let allTypes = Set([
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
        ])
        
        guard let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("Dietary energy consumed type is no longer available in HealthKit.")
            return
        }
        
        healthStore.requestAuthorization(toShare: [dietaryEnergyConsumedType], read: allTypes) { (success, error) in
            if let error = error {
                print("Error requesting HealthKit authorization: \(error)")
            } else if success {
                self.fetchUserData()
                DispatchQueue.main.async {
                    self.model.isAuthorized = true
                }
            }
        }
    }
    
    func fetchUserData() {
        self.fetchData(for: .height, into: "height", with: HKUnit.meter())
        self.fetchData(for: .bodyMass, into: "bodyMass", with: HKUnit.pound())
        self.fetchData(for: .bodyMass, into: "bodyMassKg", with: HKUnit.pound())
        self.fetchData(for: .dietaryWater, into: "dietaryWater", with: HKUnit.fluidOunceUS())
        self.fetchData(for: .stepCount, into: "steps", with: HKUnit.count())
        self.fetchStatisticQuery(for: .stepCount, into: "steps", with: .count())
        self.fetchStatisticQuery(for: .activeEnergyBurned, into: "active", with: .kilocalorie())
        self.fetchStatisticQuery(for: .basalEnergyBurned, into: "basal", with: .kilocalorie())
        self.fetchAgeAndGender()
        self.fetchCaloriesEaten()
    }
    
    func fetchData(for identifier: HKQuantityTypeIdentifier, into variable: String, with units: HKUnit) {
        let valueType = HKQuantityType.quantityType(forIdentifier: identifier)!
        let now = Date()
        let twoYearsAgo = Calendar.current.date(byAdding: .year, value: -2, to: now)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let predicate = HKQuery.predicateForSamples(withStart: twoYearsAgo, end: now, options: .strictEndDate)
        
        let query = HKSampleQuery(sampleType: valueType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples, let valueSample = samples.first as? HKQuantitySample else {
                return
            }
            
            DispatchQueue.main.async {
                let ans = valueSample
                switch variable {
                case "height":
                    self.model.HEIGHT = ans.quantity.doubleValue(for: units) * 100
                case "bodyMass":
                    self.model.BODY_MASS = ans.quantity.doubleValue(for: units)
                case "bodyMassKg":
                    self.model.BODY_MASS_KG = ans.quantity.doubleValue(for: units) * 0.45359237
                case "dietaryWater":
                    self.model.DIETARY_WATER = ans.quantity.doubleValue(for: units)
                default:
                    return
                }
            }
        }
        healthStore.execute(query)
    }
    
    
    func fetchStatisticQuery(for identifier: HKQuantityTypeIdentifier, into variable: String, with units: HKUnit) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            return
        }

        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                return
            }
            
            DispatchQueue.main.async {
                switch variable {
                    case "steps":
                        self.model.STEP_COUNT = Int(sum.doubleValue(for: units))
                    case "active":
                        self.model.ACTIVE_ENERGY_BURNED = sum.doubleValue(for: units)
                    case "basal":
                        self.model.BASAL_ENERGY_BURNED = sum.doubleValue(for: units)
                    default:
                        return
                }
            }
        }
        // Execute the query
        healthStore.execute(query)
    }
    
    func fetchAgeAndGender() {
        do {
            let birthDate = try healthStore.dateOfBirthComponents()
            let today = Calendar.current.dateComponents([.year], from: Date())
            let userAge = today.year! - birthDate.year! - 1
            let biologicalSex = try healthStore.biologicalSex()

            DispatchQueue.main.async {
                self.model.AGE = "\(userAge)"
                
                switch biologicalSex.biologicalSex.rawValue {
                    case 1:
                        self.model.GENDER = "Female"
                    case 2:
                        self.model.GENDER = "Male"
                    default:
                        self.model.GENDER = "Other"
                }
            }
        } catch {
            print("error fetching age and gender. [-]")
            return
        }
    }
    
    func fetchCaloriesEaten() {
        guard let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("Dietary energy consumed type is no longer available in HealthKit.")
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        // Create a query to retrieve dietary energy consumed samples for today
        let query = HKStatisticsQuery(quantityType: dietaryEnergyConsumedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to retrieve dietary energy consumed data")
                return
            }

            // Print the total dietary energy consumed in kilocalories
            let kilocalories = sum.doubleValue(for: HKUnit.kilocalorie())
            self.model.CALORIES_EATEN = kilocalories
        }

        // Execute the query
        healthStore.execute(query)
    }

    
    func setBMR() {
        let w:Double = self.BODY_MASS_KG
        let h:Double = self.HEIGHT
        let a:Int = Int(self.AGE)!
        
        if self.GENDER == "Male" {
            let s1 = 13.4 * w
            let s2 = 4.8 * h
            let s3 = 5.7 * Double(a)
            self.model.BMR = 88.36 + s1 + s2 - s3
        } else {
            let s1 = 9.2 * w
            let s2 = 3.1 * h
            let s3 = 4.3 * Double(a)
            self.model.BMR = 447.6 + s1 + s2 - s3
        }
        
        switch self.BMR {
            case ..<120.0:
                    print("Sedentary")
                    self.model.TDEE = self.BMR * 1.2
            case 120.0...160.0:
                    print("Light exercise")
                    self.model.TDEE = self.BMR * 1.375
            case 160...480:
                    print("In between")
                    self.model.TDEE = self.BMR * 1.4625
            case 480...560:
                    print("Active")
                    self.model.TDEE = self.BMR * 1.55
            case 560...1150:
                    print("More Active")
                    self.model.TDEE = self.BMR * 1.6375
            case 1150...1400:
                    print("Very Active")
                    self.model.TDEE = self.BMR * 1.725
            case 1400...:
                    print("Extremely Active")
                    self.model.TDEE = self.BMR * 1.9
                default:
                    print("Invalid age")
        }
    }
    
    func setGoal(newGoal:String) {
        self.model.CURRENT_GOAL = newGoal
    }
    
    func getTotalCaloriesEaten() -> Double{
        return self.CALORIES_EATEN
    }
    
    
    
    /* Nutrition Query */
    
    func nutritionQuery(queryString:String) {
        if queryString == "[]" { return }
        
        let query = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
                self.updateDietaryEnergyConsumed(calories: calories)
                
            }
        }
        task.resume()
    }

    func updateDietaryEnergyConsumed(calories: Double) {
        guard let dietaryEnergyConsumedType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) else {
            print("Dietary energy consumed type is no longer available in HealthKit.")
            return
        }
        
        let unit = HKUnit.kilocalorie()
        let quantity = HKQuantity(unit: unit, doubleValue: calories)
        let now = Date()
        let sample = HKQuantitySample(type: dietaryEnergyConsumedType, quantity: quantity, start: now, end: now)
        
        self.healthStore.save(sample) { success, error in
            if let error = error {
                print("Error saving dietary energy consumed sample: \(error.localizedDescription)")
            } else {
                print("Dietary energy consumed sample saved successfully.")
            }
        }
    }
}
