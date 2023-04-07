//
//  homepageView.swift
//  Nutrition App
//
//  Created by Paul McSlarrow on 2/13/23.
//

import SwiftUI

// Top level view that handles the tabs
struct homepageView: View {
    @ObservedObject var viewModel: HealthData
    
    var body: some View {
            TabView {
                fitFuelHomepage(viewModel: viewModel)                           // Homepage View
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                RecipeList(viewModel: self.viewModel)                         // Recipe View
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Recipes")
                    }
                
                CalorieAdder(viewModel: viewModel)                              // Profile View
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }
    }
}

struct fitFuelHomepage: View {
    var viewModel: HealthData
    
    var body: some View {
        ScrollView {
            VStack {
                                                                                //Place fit fuel image here
                Rectangle()
                    .frame(width: 175, height: 125)
                    .foregroundColor(.blue)
                
                ScrollView(.horizontal) {
                    HStack {
                        Cardify(TEXT: "Calories Burned", VALUE: String(format: "%.1f", viewModel.BASAL_ENERGY_BURNED + viewModel.ACTIVE_ENERGY_BURNED))
                        Cardify(TEXT: "Water (oz)", VALUE: String(format: "%.1f", viewModel.DIETARY_WATER))
                        Cardify(TEXT: "Weight (lbs)", VALUE: String(format: "%.1f", viewModel.BODY_MASS))

                    } //HStack
                }.padding()
                
                HStack {
                    Text("Goal: \(self.viewModel.CURRENT_GOAL)")
                        .font(Font.custom("Poppins-Medium", size: 35))
                        .padding()
                    Spacer()
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.blue)
                    GoalCircle(caloriesPerDay: String(format: "%.2f", self.viewModel.TDEE), viewModel: viewModel)
                }.padding()
            } //VStack
        }
        
    }
}


// SINGLE CARD
struct Cardify: View {
    var TEXT: String
    var VALUE: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(.blue)
                .frame(width: 250, height: 200)
            
            VStack {
                Text(VALUE).bold()
                    .font(Font.custom("Poppins-Medium", size: 60))
                    .padding(.all, 8.0)
                    .foregroundColor(.white)
                Text(TEXT)
                    .font(Font.custom("Poppins-Medium", size: 18))
                    .foregroundColor(.white)
            } //VStack
        } //ZStack
    }//body
}

// PREVIEW
struct homepageView_Previews: PreviewProvider {
    static var previews: some View {
        homepageView(viewModel: HealthData())
    }
}
