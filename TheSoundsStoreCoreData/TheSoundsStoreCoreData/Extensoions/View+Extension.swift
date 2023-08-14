//
//  View+Extension.swift
//  TheSoundsStore
//
//  Created by Andres D. Paladines on 7/19/23.
//

import SwiftUI

extension View {
        
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
