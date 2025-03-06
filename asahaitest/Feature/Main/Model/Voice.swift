//
//  Voice.swift
//  asahaitest
//
//  Created by Andi Asrafil on 06/03/25.
//

import Foundation
import SwiftUI

enum Voice: CaseIterable {
    case meadow, cypress, iris, hawke, seren, stone
}

enum VoiceGender {
    case male, female
}

extension Voice {
    var gender: VoiceGender {
        switch self {
        case .meadow, .iris, .seren:
            return .female
        default:
            return .male
        }
    }
    
    var name: String {
        switch self {
            
        case .meadow:
            return "Meadow"
        case .cypress:
            return "Cypress"
        case .iris:
            return "Iris"
        case .hawke:
            return "Hawke"
        case .seren:
            return "Seren"
        case .stone:
            return "Stone"
        }
    }
    
    var id: Int {
        switch self {
        case .meadow:
            return 1
        case .cypress:
            return 2
        case .iris:
            return 3
        case .hawke:
            return 4
        case .seren:
            return 5
        case .stone:
            return 6
        }
    }
    
    var backgroundColor: Color {
        switch gender {
        case .male:
            return .softPeach
        case .female:
            return .lightPink
        }
    }
    
    var imageUrl: URL {
        return URL(string: "https://static.dailyfriend.ai/images/voices/\(self.name.lowercased()).svg")!
    }
    
    func getRandomAudio() -> URL {
        return URL(string: "https://static.dailyfriend.ai/conversations/samples/\(id)/\(getRandomNumber())/audio.mp3")!
    }
    
    func getRandomNumber() -> Int {
        let randomNumber = Int.random(in: 1...20)
        return randomNumber
    }
    
    func playList() -> [URL] {
        var data: [URL] = []
        for index in 1...20 {
            data.append(URL(string: "https://static.dailyfriend.ai/conversations/samples/\(id)/\(index)/audio.mp3")!)
        }
        return data
    }
}
