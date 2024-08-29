//
//  ErrorView.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/23/24.
//

import SwiftUI

struct ErrorView: View {
    public var errorMessage: String
    
    var body: some View {
        VStack {
            Text("Something went wrong")
                .fontWeight(.medium)
            Text(errorMessage)
                .multilineTextAlignment(.center)
        }.padding(.top, 50)
    }
}

#Preview {
    ErrorView(errorMessage: "Data wasn't found")
}
