//
//  RadioButton.swift
//  asahaitest
//
//  Created by Andi Asrafil on 06/03/25.
//
import SwiftUI
struct RadioButton: View {
    let isSelected: Bool
    
    var body: some View {
        if isSelected {
            selected
        } else {
            unselected
        }
    }
    
    var unselected: some View {
        Circle()
            .stroke(
                .gray, style: StrokeStyle(lineWidth: 2)
            )
            .foregroundStyle(.gray)
            .frame(width: 16, height: 16)
    }
    
    var selected: some View {
        ZStack {
            Circle()
                .stroke(
                    .softOrange, lineWidth: 4
                )
                .foregroundStyle(.softOrange)
            Circle()
                .frame(width: 8)
                .foregroundStyle(.softOrange)
                
        }
        .frame(width: 16, height: 16)
    }
}
