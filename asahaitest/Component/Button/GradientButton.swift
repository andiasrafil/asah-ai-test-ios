//
//  GradientButton.swift
//  asahaitest
//
//  Created by Andi Asrafil on 06/03/25.
//

import SwiftUI
struct GradientButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .bold()
            .foregroundStyle(.white)
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(.linearGradient(colors: [.softOrange, .softOrange.opacity(0.5)], startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
