//
//  SwiftUIView.swift
//  
//
//  Created by Vyacheslav Konopkin on 22.02.2023.
//

import SwiftUI

public struct ErrorView: View {
    private let title: String
    private let error: Error
    private let onTryAgain: (() -> Void)

    @State private var isShown = false

    public init(title: String,
                error: Error,
                onTryAgain: @escaping (() -> Void)) {
        self.title = title
        self.error = error
        self.onTryAgain = onTryAgain
    }

    public var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .bold()
                Text(error.localizedDescription)
            }

            VStack(alignment: .center) {
                Divider()
                Button("Try again") {
                    withAnimation {
                        onTryAgain()
                    }
                }
            }
        }
        .padding()
        .background(.red)
        .foregroundColor(.white)
        .cornerRadius()
        .padding()
        .transition(.moveTop)
    }
}

private extension AnyTransition {
    static var moveTop: AnyTransition {
        .move(edge: .top).combined(with: .opacity)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(title: "Error",
                  error: URLError(.badURL)) {

        }
    }
}
