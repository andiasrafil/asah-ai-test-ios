//
//  ToastView.swift
//  asahaitest
//
//  Created by Andi Asrafil on 07/03/25.
//

import SwiftUI

extension View {
    func toastView(showToast: Binding<Bool>, message: String, isError: Bool = false, onDismiss: @escaping () -> Void) -> some View {
        modifier(ToastViewModifier(showToast: showToast, message: message, isError: isError, onDismiss: onDismiss))
    }
}

struct ToastViewModifier: ViewModifier {
    @Binding var showToast: Bool
    let message: String
    let isError: Bool
    let onDismiss: () -> Void
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if showToast {
                ToastView(message: message, isError: isError, onDismiss: {
                    showToast.toggle()
                    onDismiss()
                })
                    .padding()
            }
        }
    }
}

struct ToastView: View {
    var message: String
    var isError: Bool
    var onDismiss: () -> Void
    
    @State private var opacity: Double = 0
    
    var body: some View {
        HStack(spacing: 12) {
            if isError {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.white)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(isError ? Color.red.opacity(0.9) : Color.black.opacity(0.7))
        .cornerRadius(30)
        .opacity(opacity)
        .onAppear {
            // Fade in animation
            withAnimation(.easeInOut(duration: 0.3)) {
                opacity = 1.0
            }
            
            // Auto-dismiss after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    opacity = 0.0
                }
                // Call dismiss after animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onDismiss()
                }
            }
        }
    }
}
