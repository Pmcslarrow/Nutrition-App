import Foundation
import SwiftUI
import HealthKit
 

struct ContentView: View {
    @ObservedObject var viewModel = HealthData()
    
    var body: some View {
            if viewModel.isAuthorized {
                VStack {
                    homepageView(viewModel: viewModel)
                }
            } else {
                VStack {
                    Button(action: viewModel.requestAccess) {
                        Text("Request HealthKit Access")
                    }.padding()
                    Text("For a more accurate experience, please go update any data inside your Health App (height, weight, etc...)").multilineTextAlignment(.center).padding(.all, 50.0)
                }
                
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
