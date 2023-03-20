//
//  UISheetPresentationControllerDetent+small.swift
//  
//
//  Created by Vyacheslav Konopkin on 16.03.2023.
//

import UIKit

extension UISheetPresentationController.Detent.Identifier {
    public static let fraction = UISheetPresentationController.Detent.Identifier("small")
}

extension UISheetPresentationController.Detent {
    public static func fraction(_ value: Float) -> UISheetPresentationController.Detent {
        .custom(identifier: .fraction) { $0.maximumDetentValue * CGFloat(value) }
    }
}
