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
    private let onTryAgain: (() -> Void)?

    @State private var isShown = true

    public init(title: String,
                error: Error,
                onTryAgain: (() -> Void)? = nil) {
        self.title = title
        self.error = error
        self.onTryAgain = onTryAgain
    }

    public var body: some View {
        VStack {
            if isShown {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title2)
                            .bold()
                        Text(error.localizedDescription)
                    }

                    VStack(alignment: .center) {
                        Divider()
                        if let onTryAgain {
                            Button("Try again") {
                                withAnimation(.easeInOut) {
                                    onTryAgain()
                                    isShown = false
                                }
                            }
                        } else {
                            Button("Try again later") {
                                isShown = false
                            }
                        }
                    }
                }
                .padding()
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(8.0)
                .padding()
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
        .animation(.default, value: isShown)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(title: "Error",
                  error: URLError(.badURL)) {

        }
    }
}
