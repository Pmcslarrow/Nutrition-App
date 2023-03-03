//
//  CalorieAdder.swift
//  Nutrition App
//
//  Created by Paul McSlarrow on 2/24/23.
//

import SwiftUI

struct CalorieAdder: View {
    var viewModel: HealthData
    @State var userInput: String = ""
    
    var body: some View {
        ZStack {
            CustomColor.myBackground
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    TextField("Enter what you ate", text: $userInput)
                        .padding()
                        .border(CustomColor.myLightGreen)
                    Spacer()
                }
                
                Button("Submit") {
                    viewModel.nutritionQuery(queryString: userInput)
                    viewModel.fetchUserData()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                VStack {
                    Text("Example query: '1lb brisket and fries' ")
                    Text("All data submitted goes to your health app")
                }.font(.system(size: 12))
            }
        }.foregroundColor(.black)
    }
}

struct CalorieAdder_Previews: PreviewProvider {
    static var previews: some View {
        CalorieAdder(viewModel: HealthData())
    }
}
