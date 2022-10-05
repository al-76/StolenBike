//
//  ErrorView.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 02.10.2022.
//

import SwiftUI

struct ErrorView: View {
    let error: Error

    var body: some View {
        Label {
            Text("Error: \(error.localizedDescription)")
        } icon: {
            Image(systemName: "xmark.app")
                    .foregroundColor(Color.red)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: URLError(.badURL))
    }
}
