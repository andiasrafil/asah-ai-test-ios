//
//  LottieView.swift
//  asahaitest
//
//  Created by Andi Asrafil on 05/03/25.
//

import Lottie
import SwiftUI
import Combine

struct LottiePlayer: View {
    var url: URL
    @State var playBackMode: LottiePlaybackMode
    @State var isFinished = false
    let action: PassthroughSubject<LottiePlayer.Action, Never>
    @State var progress: CGFloat = 0
    var body: some View {
        LottieView {
            await LottieAnimation.loadedFrom(url: url)
        } placeholder: {
            ProgressView()
        }
        .animationDidLoad { _ in
            DispatchQueue.main.async {
                self.isFinished = false
            }
        }
        
        .animationDidFinish { _ in
            DispatchQueue.main.async {
                self.playBackMode = .paused
                self.isFinished = true
            }
        }
        .reloadAnimationTrigger(self.isFinished)
        .playbackMode(playBackMode)
        .getRealtimeAnimationProgress($progress)
        .onReceive(action, perform: { action in
            self.isFinished = false
            switch action {
            case .play:
                DispatchQueue.main.async {
                    self.isFinished = true
                }
                self.playBackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
            case .pause:
                self.playBackMode = .paused
            }
        })
    }
    
    enum Action {
        case play
        case pause
    }
}

