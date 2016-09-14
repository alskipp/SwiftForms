//
//  FunctionalAdditions.swift
//  SwiftFormsApplication
//
//  Created by Alan Skipp on 25/07/2015.
//  Copyright (c) 2015 Alan Skipp. All rights reserved.
//

extension Collection where Iterator.Element == String {
    func join(_ joiner: String) -> String {
        return self.dropFirst().reduce(self.first ?? "") { str, elem in "\(str)\(joiner)\(elem)" }
    }
}
