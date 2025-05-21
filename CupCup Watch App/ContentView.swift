//
//  ContentView.swift
//  CupCup Watch App
//
//  Created by Muhammad Ardiansyah Asrifah on 21/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.blue
                .edgesIgnoringSafeArea(.all)
            VStack() {
                Text("Choose The Cup")
                    .font(.system(size: 20, weight: .bold, design: .default))
                
                HStack(spacing: 20) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 50, height: 100)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 50, height: 100)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 50, height: 100)
                }
                .padding(.top, 20)
            }
            
            
        }
        
        
    }
}

#Preview {
    ContentView()
}
