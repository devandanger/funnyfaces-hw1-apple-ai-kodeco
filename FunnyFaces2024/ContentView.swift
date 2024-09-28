//
//  ContentView.swift
//  FunnyFaces2024
//
//  Created by Evan Anger on 9/28/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                
            }, label: {
                HStack {
                    Text("Via Camera")
                    Spacer()
                }
                .padding()
            })
            .buttonStyle(BorderedButtonStyle())
            Button(action: {
                
            }, label: {
                HStack {
                    Text("Via Library")
                    Spacer()
                }
                .padding()
            })
            .buttonStyle(BorderedButtonStyle())
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
