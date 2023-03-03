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
                HOMEPAGE(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                GoalBuilderView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "figure.run")
                        Text("Goal Achiever")
                    }
                
                CalorieAdder(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "plus.app")
                        Text("Add Calories")
                    }
            }            
    }
}

// The view that holds the structure of the home page
struct HOMEPAGE: View {
    var viewModel: HealthData
    
    var body: some View {
        ZStack {
            CustomColor.myBackground
                .ignoresSafeArea()
            VStack {
                Text("Homepage")
                    .padding()
                    .font(Font.custom("Poppins-Medium", size: 30))
                cardStats(viewModel: viewModel)
            }
        }
    }
}


// GRID OF CARDS
struct cardStats: View {
    var viewModel: HealthData
    
    var statsColumns: [GridItem] {
      [GridItem(.adaptive(minimum: 150, maximum: 180))]
    }
    
    var body: some View {
        ScrollView {
            Spacer()
            LazyVGrid(columns: statsColumns) {
                Cardify(TEXT: "Height:" , VALUE: String(format: "%.2f", viewModel.HEIGHT) + " cm")
                Cardify(TEXT: "Weight:", VALUE: String(format: "%.2f", viewModel.BODY_MASS) + " lbs")
                Cardify(TEXT: "Age:" , VALUE: String(viewModel.AGE) + " yrs")
                Cardify(TEXT: "Gender:", VALUE: String(viewModel.GENDER))
                Cardify(TEXT: "Water:", VALUE: String(format: "%.2f", viewModel.DIETARY_WATER) + " fl oz")
                Cardify(TEXT: "Steps:", VALUE: String(viewModel.STEP_COUNT))
                Cardify(TEXT: "Active Energy:", VALUE: String(format: "%.2f", viewModel.ACTIVE_ENERGY_BURNED) + " cal")
                Cardify(TEXT: "Basal Energy:", VALUE: String(format: "%.2f", viewModel.BASAL_ENERGY_BURNED) + " cal")
                Cardify(TEXT: "Total Calories Burned:", VALUE: String(format: "%.2f", viewModel.BASAL_ENERGY_BURNED + viewModel.ACTIVE_ENERGY_BURNED) + " cal")
            }
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
                .fill(CustomColor.myLightGreen)
                .frame(width: 170, height: 200)
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .stroke(CustomColor.myDarkGreen,lineWidth: 4)
                .frame(width: 170, height: 200)
                .padding(.vertical, 5.0)
            VStack {
                Text(TEXT).bold()
                    .font(Font.custom("Poppins-Medium", size: 25))
                    .padding(.all, 8.0)
                    .foregroundColor(.black)
                Text(VALUE)
                    .font(Font.custom("Poppins-Medium", size: 15))
                    .foregroundColor(.black)
            }.padding()
        }
    }
}

// PREVIEW
struct homepageView_Previews: PreviewProvider {
    static var previews: some View {
        homepageView(viewModel: HealthData())
    }
}
