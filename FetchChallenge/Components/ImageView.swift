//
//  ImageView.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/28/24.
//

import SwiftUI

struct ImageView: View {
    public var url: URL?
    public var width: CGFloat?
    public var height: CGFloat
    public var cornerRadius: CGFloat
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: width, height: height)
                        .frame(maxWidth: width == nil ? .infinity : nil)
                        .clipShape(.rect(cornerRadius: cornerRadius))
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .frame(maxWidth: width == nil ? .infinity : nil)
                        .clipShape(.rect(cornerRadius: cornerRadius))
                case .failure:
                    Image("NoImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .frame(maxWidth: width == nil ? .infinity : nil)
                        .clipShape(.rect(cornerRadius: cornerRadius))
                @unknown default:
                    Image("NoImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .frame(maxWidth: width == nil ? .infinity : nil)
                        .clipShape(.rect(cornerRadius: cornerRadius))
                }
            }
        } else {
            Image("NoImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .frame(maxWidth: width == nil ? .infinity : nil)
                .clipShape(.rect(cornerRadius: cornerRadius))
        }
    }
}

#Preview {
    ImageView(url: URL(string: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg")!, width: 70, height: 70, cornerRadius: 10)
}
