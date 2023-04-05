//
//  File.swift
//  
//
//  Created by Vyacheslav Konopkin on 16.03.2023.
//

import Combine
import SwiftUI
import UIKit

final class BottomSheetViewController<Content: View>: UIViewController,
                                                      UISheetPresentationControllerDelegate,
                                                      ObservableObject {
    private let detents: [UISheetPresentationController.Detent]
    private let contentView: UIHostingController<Content>
    private var cancellable: AnyCancellable?

    @Published var selectedDetentId: UISheetPresentationController.Detent.Identifier?

    init(detents: [UISheetPresentationController.Detent],
         content: Content,
         selectedDetentId: UISheetPresentationController.Detent.Identifier?) {
        self.detents = detents
        self.contentView = UIHostingController(rootView: content)

        super.init(nibName: nil, bundle: nil)

        self.selectedDetentId = selectedDetentId
        self.isModalInPresentation = true

        cancellable = $selectedDetentId
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detentId in
                guard let sheet = self?.presentationController as? UISheetPresentationController else {
                    return
                }
                sheet.animateChanges {
                    sheet.selectedDetentIdentifier = detentId
                }
            }
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

        guard let sheet = presentationController as? UISheetPresentationController else {
            return
        }

        sheet.detents = detents
        sheet.prefersGrabberVisible = true
        sheet.delegate = self
        sheet.largestUndimmedDetentIdentifier = .medium
    }

    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        selectedDetentId = sheetPresentationController.selectedDetentIdentifier
    }
}
