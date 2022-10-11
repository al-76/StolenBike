//
//  Mapper.swift
//  StolenBike
//
//  Created by Vyacheslav Konopkin on 09.10.2022.
//

protocol Mapper<Input, Output> {
    associatedtype Input
    associatedtype Output

    func map(input: Input) -> Output
}
