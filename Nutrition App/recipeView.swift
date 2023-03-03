//
//  recipeView.swift
//  Nutrition App
//
//  Created by Paul McSlarrow on 2/16/23.
//

import SwiftUI

// The swipe up menu that holds the information about how many calories are left
struct recipeView: View {
    var viewModel: HealthData
    
    var body: some View {
        if viewModel.CURRENT_GOAL == "none" {
            Text("Please try again.")
        } else {
            VStack {
                if viewModel.CURRENT_GOAL == "maintain" {
                    goalify(string: String(format: "%.2f", self.viewModel.TDEE), viewModel: viewModel)
                } else if viewModel.CURRENT_GOAL == "lose" {
                    goalify(string: String(format: "%.2f", self.viewModel.TDEE - 500.0), viewModel: viewModel)
                } else if viewModel.CURRENT_GOAL == "gain" {
                    goalify(string: String(format: "%.2f", self.viewModel.TDEE + 500.0), viewModel: viewModel)
                }
            }.padding()
        }
    }
        
}

// Returns a view that looks like a card and shows a string (typically the TDEE) as a dark green card.
struct goalify: View {
    var string: String
    var viewModel: HealthData
    
    var body: some View {
        VStack {
            /* Card containing number of calories per day*/
            ZStack {
                RoundedRectangle(cornerRadius: 20).foregroundColor(CustomColor.myDarkGreen)
                VStack {
                    VStack {
                        Text(string)
                            .foregroundColor(.white)
                        Text("calories per day")
                            .foregroundColor(.white)
                            .font(Font.custom("Poppins-Medium", size: 15))
                    }
                    
                    Text("It is recommended that about 50% of the plate filled with vegetables and fruits; 25% of the plate is filled with whole grains or complex carbohydrates; and about 25% of the plate filled with lean protein such as chicken, fish, beans, or tofu").foregroundColor(.white)
                        .padding()
                        .font(Font.custom("Poppins-Medium", size: 15))
                }.padding()
            }
            .padding()
            .font(Font.custom("Poppins-Medium", size: 50))
            
            Spacer()
            
            /* Card Containing number of calories left to eat today */
            ZStack {
                RoundedRectangle(cornerRadius: 20).foregroundColor(CustomColor.myDarkGreen)
                GoalCircle(caloriesPerDay: string, viewModel: viewModel)
            }
            .padding()
            .font(Font.custom("Poppins-Medium", size: 15))
        }
    }
}


struct GoalCircle: View {
    var caloriesPerDay: String
    var viewModel: HealthData
    var totalCaloriesEaten: Double {
        return viewModel.getTotalCaloriesEaten()
    }
    var progress: Double {
        let total = totalCaloriesEaten / Double(caloriesPerDay)!
        if total > 1.0 {
            return 1.0
        } else {
            return total
        }
    }
        
    // Main content holding the progress circle
    var body: some View {
        ZStack {
            VStack {
                if (progress == 1.0) {
                    Text("Complete (+\(String(format: "%.2f", totalCaloriesEaten - Double(caloriesPerDay)!)) cal)")
                } else {
                    Text("\(String(format: "%.2f", Double(caloriesPerDay)! - totalCaloriesEaten))")
                    Text("calories left")
                }
            }
            .foregroundColor(.white)
            .font(Font.custom("Poppins-Medium", size: 20))
            
            progressCircle
        }
        .frame(width: 200, height: 200.0)
    }
    
    //The actual progress circle stacked ontop of eachother
    var progressCircle: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.green)
            
            Circle()
                .trim(from: 0.0, to: self.progress)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
        }
    }
    
}

struct recipeView_Previews: PreviewProvider {
    static var previews: some View {
        goalify(string: "3164", viewModel: HealthData())
    }
}
