//
//  SwiftUIView.swift
//  
//
//  Created by Vyacheslav Konopkin on 11.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

public struct DownloadImageView: View {
    private let url: URL?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        if let url {
            WebImage(url: url)
                .placeholder { ProgressView() }
                .resizable()
                .scaledToFit()
                .transition(.fade(duration: 0.5))
        } else {
            Image(systemName: "photo")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.blue, .yellow, .red)
        }
    }
}

struct DownloadImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageView(url: nil)//URL(string: "https://files.bikeindex.org/uploads/Pu/677396/small_20211028_145926.jpg"))
    }
}
