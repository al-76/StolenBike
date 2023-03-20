//
//  BikeMapRowView.swift
//  
//
//  Created by Vyacheslav Konopkin on 09.03.2023.
//

import SwiftUI

import BikeClient
import Utils

struct BikeMapRowView: View {
    let bike: Bike

    var body: some View {
        HStack {
            Group {
                VStack {
                    Text(bike.title)
                        .font(.headline)
                    if let date = bike.dateStolen {
                        Text((date.formatted(date: .abbreviated, time: .shortened)))
                        .font(.subheadline)
                    }
                }
                Spacer()
                DownloadImageView(url: bike.thumbImageUrl)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12.0)
            }
        }
    }
}

struct BikeMapRowView_Previews: PreviewProvider {
    static var previews: some View {
        BikeMapRowView(bike: .stub)
    }
}
