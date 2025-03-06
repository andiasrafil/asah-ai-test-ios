//
//  VoiceCard.swift
//  asahaitest
//
//  Created by Andi Asrafil on 06/03/25.
//

import SwiftUI
import SDWebImageSwiftUI
import AVFoundation

struct VoiceCard: View {
    let voice: Voice
    let isSelected: Bool
    let isPlaying: Bool
    let onTap: () -> Void
    @State private var opacity = 1.0
    @State private var lineWidth = 4.0
    
    var body: some View {
        Button(action: {
            onTap()
        }, label: {
            VStack(spacing: 0) {
                HStack {
                    Text(voice.name)
                    Spacer()
                    RadioButton(isSelected: isSelected)
                }
                .padding([.horizontal, .top])
                Spacer()
                WebImage(url: voice.imageUrl)
                    .resizable()
                    .frame(width: 120, height: 100)
            }
            .frame(width: 150, height: 150)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(voice.backgroundColor)
                    .stroke(isSelected ? .softOrange.opacity(opacity) : .clear, lineWidth: lineWidth)
            )
        })
        .buttonStyle(GrowingButton())
        .disabled(isPlaying)
        .onChange(of: isPlaying) { oldValue, newValue in
            if isSelected {
                if newValue {
                    // Start the animation when isPlaying becomes true
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        opacity = 0.3  // Animate to lower opacity
                        lineWidth = 10.0
                    }
                } else {
                    // Stop the animation when isPlaying becomes false
                    withAnimation(.default) {
                        opacity = 1.0  // Reset to full opacity
                        lineWidth = 4.0
                    }
                }
            }
        }
        .onChange(of: isSelected) { oldValue, newValue in
            // Update opacity when selection state changes
            if newValue {
                opacity = 1.0
                lineWidth = 4.0
                if isPlaying {
                    // Start animation if it's both selected and playing
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        opacity = 0.3
                        lineWidth = 10.0
                    }
                }
            }
        }
    }
}
