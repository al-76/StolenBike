//
//  BottomSheetView.swift
//  
//
//  Created by Vyacheslav Konopkin on 16.03.2023.
//

import SwiftUI
import UIKit

public struct BottomSheetView<ContentView: View>: ViewModifier {
    @StateObject private var bottomSheet: BottomSheetViewController<ContentView>
    @Binding private var selectedDetentId: UISheetPresentationController.Detent.Identifier

    public init(detents: [UISheetPresentationController.Detent],
                contentView: @escaping () -> ContentView,
                selectedDetentId: Binding<UISheetPresentationController.Detent.Identifier>) {
        self._bottomSheet = StateObject(
            wrappedValue: BottomSheetViewController(detents: detents,
                                                    content: contentView(),
                                                    selectedDetentId: selectedDetentId.wrappedValue)
        )
        self._selectedDetentId = selectedDetentId
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
        .onChange(of: bottomSheet.selectedDetentId) { selectedDetentId in
            guard let selectedDetentId else { return }
            self.selectedDetentId = selectedDetentId
        }
        .onChange(of: selectedDetentId) {
            bottomSheet.selectedDetentId = $0
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
            Text("text")
        }
    }
}
