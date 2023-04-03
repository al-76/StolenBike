//
//  File.swift
//  
//
//  Created by Vyacheslav Konopkin on 16.03.2023.
//

import SwiftUI
import UIKit

final class BottomSheetViewController<Content: View>: UIViewController,
                                                      UISheetPresentationControllerDelegate {
    private let detents: [UISheetPresentationController.Detent]
    private let contentView: UIHostingController<Content>
    private let onChangedDetent: ((UISheetPresentationController.Detent.Identifier) -> Void)?

    init(detents: [UISheetPresentationController.Detent],
         content: Content,
         onChangedDetent: ((UISheetPresentationController.Detent.Identifier) -> Void)?) {
        self.detents = detents
        self.contentView = UIHostingController(rootView: content)
        self.onChangedDetent = onChangedDetent

        super.init(nibName: nil, bundle: nil)

        self.isModalInPresentation = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(contentView)
        view.addSubview(contentView.view)

        contentView.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        guard let sheetController = presentationController as? UISheetPresentationController else {
            return
        }

        sheetController.detents = detents
        sheetController.prefersGrabberVisible = true
        sheetController.delegate = self
        sheetController.largestUndimmedDetentIdentifier = .medium
    }

    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        guard let detentId = sheetPresentationController.selectedDetentIdentifier else {
            return
        }
        onChangedDetent?(detentId)
    }
}
