//
//  BottomSheetView.swift
//  
//
//  Created by Vyacheslav Konopkin on 16.03.2023.
//

import SwiftUI
import UIKit

public struct BottomSheetView<ContentView: View>: ViewModifier {
    private let bottomSheet: BottomSheetViewController<ContentView>

    public init(detents: [UISheetPresentationController.Detent],
                contentView: () -> ContentView,
                selectedDetentId: Binding<UISheetPresentationController.Detent.Identifier>) {
        self.bottomSheet = BottomSheetViewController(detents: detents, content: contentView()) {
            selectedDetentId.wrappedValue = $0
        }
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            guard !bottomSheet.isBeingPresented,
                  let window = UIApplication
                .shared
                .connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                .first,
                  let root = window.rootViewController else {
                return
            }

            var topViewController = root
            while let presented = topViewController.presentedViewController {
                topViewController = presented
            }

            topViewController.present(bottomSheet, animated: true)
        }
    }
}

extension View {
    public func bottomSheet<ContentView: View>(
        detents: [UISheetPresentationController.Detent],
        selectedDetentId: Binding<UISheetPresentationController.Detent.Identifier>,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) -> some View {
        modifier(BottomSheetView(detents: detents,
                                 contentView: contentView,
                                 selectedDetentId: selectedDetentId))
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Button("Click") { }
            .bottomSheet(detents: [.fraction(0.2),
                                   .medium(),
                                   .large()],
                         selectedDetentId: .constant(.fraction)) {
                Text("Some text")
            }
    }
}
