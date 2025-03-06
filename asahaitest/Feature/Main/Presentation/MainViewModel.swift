//
//  Main.swift
//  asahaitest
//
//  Created by Andi Asrafil on 05/03/25.
//
import SwiftUI
import RiveRuntime
@Observable class MainViewModel: RiveViewModel {
    var voices: [Voice] = Voice.allCases
    var selectedVoice: Voice?
    
    init() {
        super.init(fileName: "asahai", fit: .noFit, autoPlay: false)
    }
    
    func setSelected(voice: Voice) {
        self.selectedVoice = voice
    }
}

