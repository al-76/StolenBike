//
//  BikeGalleryView.swift
//  
//
//  Created by Vyacheslav Konopkin on 24.03.2023.
//

import SwiftUI

import BikeClient
import Utils

struct BikeGalleryView: View {
    let images: [BikeImage]?

    @State var selected: BikeImage?

    var body: some View {
        VStack {
            if let images, !images.isEmpty {
                ZStack {
                    if let selected {
                        DownloadImageView(url: selected.large)
                    }
                }
                .frame(height: 300)

                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(images) { image in
                            Group {
                                if image == selected {
                                    DownloadImageView(url: image.thumb)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: ViewStyle.cornerRadius)
                                                .stroke(Color.blue,
                                                        lineWidth: 8.0)
                                        )
                                } else {
                                    DownloadImageView(url: image.thumb)
                                        .onTapGesture {
                                            selected = image
                                        }
                                }
                            }
                            .cornerRadius()
                        }
                    }
                }
                .frame(height: 100)
            } else {
                Image(systemName: "bicycle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .foregroundColor(.blue)
                    .cornerRadius()
            }
        }
        .onAppear {
            if selected == nil {
                selected = images?.first
            }
        }
    }
}

struct BikeGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        BikeGalleryView(images: BikeDetails.stub.publicImages)
    }
}
