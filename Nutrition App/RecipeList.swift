//
//  RecipeList.swift
//  Nutrition App
//
//  Created by Paul McSlarrow on 4/6/23.
//

import SwiftUI

struct RecipeList: View {
    var viewModel: HealthData
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(self.viewModel.list_of_recipes, id: \.title) { dataPoint in
                    NavigationLink {
                        SelectedRecipe(viewModel: self.viewModel, data: dataPoint)
                    } label: {
                        Text(dataPoint.title)
                    }
                }
            }.navigationTitle("Recipes")
        }
        .font(Font.custom("Poppins-Medium", size: 15))
    }
}


struct SelectedRecipe: View {
    var viewModel: HealthData
    var data: Recipe
    
    var body: some View {
        VStack {
            Image(data.image_url)
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                Rectangle()
                    //.cornerRadius(25)
                    .foregroundColor(.blue)
                    .edgesIgnoringSafeArea(.bottom)
                
                VStack {
                    Text(data.title)
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Medium", size: 25))
                    Spacer()
                    
                    VStack {
                        HStack {
                            Image(systemName: "flame")
                                .font(.system(size: 25))
                                .foregroundColor(.orange)
                            Text("\(data.nCalories) cal")
                                .font(Font.custom("Poppins-Medium", size: 40))
                                .foregroundColor(.white)
                        }
                        
                        HStack {
                            Text("Protein: \(data.protein)g   ")
                            Text("Carbs: \(data.carbs)g     ")
                            Text("Fat: \(data.fat)g")
                        }
                        .font(Font.custom("Poppins-Medium", size: 18))
                        .foregroundColor(.white)
                        .padding()
                    }
                    Spacer()
                    
                    
                    Link("Link to Recipe", destination: URL(string: self.data.url)!)
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                }.padding(.vertical, 10.0)
            }
        }
    }
}


struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList(viewModel: HealthData())
    }
}

struct SelectedPreview: PreviewProvider {
    static var previews: some View {
        SelectedRecipe(viewModel: HealthData(), data: Recipe(title: "Honey Garlic Chicken", nCalories: "258", protein: "25", fat: "12", carbs:"18", url:"https://www.delish.com/cooking/recipe-ideas/recipes/a49507/honey-garlic-chicken-recipe/", image_url: "honey_garlic"))
    }
}
