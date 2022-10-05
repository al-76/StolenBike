//
//  ViewModelState.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 02.10.2022.
//

import Foundation

enum ViewModelState<T> {
    case loading
    case success(T)
    case failure(Error)
}
