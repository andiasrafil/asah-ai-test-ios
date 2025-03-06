//
//  MainView.swift
//  asahaitest
//
//  Created by Andi Asrafil on 05/03/25.
//

import SwiftUI
import RiveRuntime
import Combine


struct MainView: View {
    @State var viewModel: MainViewModel = MainViewModel()
    @State var audioPlayer: AudioPlayer = AudioPlayer()
    var body: some View {
        ScrollView(.vertical, content: {
            VStack {
                title
                riveAsset
                subtitle
                voiceGrid
            }
            .padding()
            .padding(.bottom, 80)
        })
        .scrollIndicators(.hidden)
        .onChange(of: self.audioPlayer.isPlaying, { _, newValue in
            if newValue {
                self.viewModel.stop()
                self.viewModel.play()
            } else {
                self.viewModel.stop()
            }
        })
        .overlay(alignment: .bottom, content: {
            button
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.white)
        })
        .toastView(showToast: self.$audioPlayer.showToast, message: audioPlayer.errorMessage ?? "", isError: audioPlayer.errorMessage != nil, onDismiss: {
        })
        .background(Color.white)
    }
    
    var title: some View {
        Text("Pick My Voice")
            .font(.headline)
            .foregroundStyle(.black)
    }
    
    var subtitle: some View {
        Text("Find the voice that resonates with you")
            .font(.subheadline)
            .foregroundStyle(.black)
    }
    
    var riveAsset: some View {
        self.viewModel.view().frame(width: 150, height: 150)
    }
    
    var button: some View {
        Button(action: {
            self.audioPlayer.play(urls: self.viewModel.selectedVoice!.playList())
        }, label: {
            Text("Next")
        })
        .buttonStyle(GradientButton())
        .disabled(self.viewModel.selectedVoice == nil)
    }
    
    var voiceGrid: some View {
        LazyVGrid(columns: [
            GridItem(.fixed(150), spacing: 24),
            GridItem(.fixed(150), spacing: 24),
        ],spacing: 16, content: {
            ForEach(self.viewModel.voices, id: \.self, content: { voice in
                VoiceCard(voice: voice, isSelected: self.viewModel.selectedVoice == voice, isPlaying: self.audioPlayer.isPlaying, onTap: {
                    if !self.audioPlayer.isPlaying {
                        self.viewModel.setSelected(voice: voice)
                        self.audioPlayer.play(url: voice.getRandomAudio())
                    }
                })
            })
        })
    }
}
