//
//  GoalBuilderView.swift
//  Nutrition App
//
//  Created by Paul McSlarrow on 2/14/23.
//

import SwiftUI

// The GoalBuilderView is the page where the user can see their progress of the day and match the calories they are eating with their goal
struct GoalBuilderView: View {
    var viewModel: HealthData
    @State var recipeSectionClicked = false
    
    
    var body: some View {
        
        ZStack {
            CustomColor.myLightGreen
                .ignoresSafeArea()
            VStack {
                Text("Goal Achiever")
                    .font(Font.custom("Poppins-Medium", size: 30))
                Text(String(viewModel.BODY_MASS) + " lbs")
                    .padding(.bottom)

   
                HStack {
                    GoalButton(string: "Lose", viewModel: viewModel)
                    GoalButton(string: "Maintain", viewModel: viewModel)
                    GoalButton(string: "Gain", viewModel: viewModel)
                    
                }
            }
        }
        .onAppear {
            viewModel.fetchUserData()
        }
    }
}

// Returns a dark green button, when clicked, will set the new goal and bring up the hidden sheet section
struct GoalButton: View {
    let string: String
    let viewModel: HealthData
    @State var recipeSectionClicked: Bool = false
    
    var body: some View {
        HStack {
            Button(string) {
                viewModel.setGoal(newGoal: string.lowercased())
                self.viewModel.setBMR()
                self.recipeSectionClicked.toggle()
            }.buttonStyle(PrimaryButtonStyle())
        }
        .sheet(isPresented: $recipeSectionClicked) {
            recipeView(viewModel: viewModel)
                .presentationDetents([.large])
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(CustomColor.myDarkGreen)
            .clipShape(Capsule())
            .foregroundColor(.white)
            .padding()
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct GoalBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        GoalBuilderView(viewModel: HealthData())
    }
}
