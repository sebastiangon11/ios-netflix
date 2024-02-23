//
//  Extensions.swift
//  Netflix
//
//  Created by Seba Gonzalez on 18/01/2024.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
