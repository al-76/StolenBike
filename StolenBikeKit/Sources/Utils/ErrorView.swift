//
//  SwiftUIView.swift
//  
//
//  Created by Vyacheslav Konopkin on 22.02.2023.
//

import SwiftUI

public struct ErrorView: View {
    private let title: String
    private let tryAgainTitle: String
    private let error: Error
    private let onTryAgain: (() -> Void)
    private let onCancel: (() -> Void)?

    @State private var isShown = false

    public init(title: String,
                tryAgainTitle: String = "Try again",
                error: Error,
                onTryAgain: @escaping (() -> Void),
                onCancel: (() -> Void)? = nil) {
        self.title = title
        self.tryAgainTitle = tryAgainTitle
        self.error = error
        self.onTryAgain = onTryAgain
        self.onCancel = onCancel
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
                HStack {
                    button(title: tryAgainTitle) {
                        onTryAgain()
                    }

                    if let onCancel {
                        button(title: "Cancel") {
                            onCancel()
                        }
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

    private func button(title: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Text(title)
                .frame(maxWidth: .infinity)
                .bold()
        }
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
        } onCancel: {
        }

        ErrorView(title: "Error",
                  error: URLError(.badURL)) {
        }.previewDisplayName("Error View without Cancel")
    }
}
