//
//  CustomText.swift
//  Recipes
//
//  Created by michal zak on 07/10/2024.
//

import SwiftUI

struct CustomText: View {
    var text: String
    var customFont: String
    var size: CGFloat = 16
    var textColor: Color = .black
    var alignment: TextAlignment = .leading

    var body: some View {
        Text(text)
            .font(.custom(customFont, size: size))
            .foregroundColor(textColor)
            .multilineTextAlignment(alignment)
    }
}


