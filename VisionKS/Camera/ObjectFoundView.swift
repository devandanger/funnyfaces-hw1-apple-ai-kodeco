//
//  ObjectFoundView.swift
//  Camera
//
//  Created by Evan Anger on 10/8/22.
//

import SwiftUI

struct ObjectFoundView: View {
    var body: some View {
        HStack {
            Image(systemName: "questionmark.app.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(Color(uiColor: UIColor.brownFound))
            Text("Unidentified")
            Spacer()
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        .frame(width: 175)
        .background(Color(uiColor: UIColor.yellowFound))
        .cornerRadius(8)
    }
}

struct ObjectFoundView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                ObjectFoundView()
                Spacer()
            }
        }
    }
}
