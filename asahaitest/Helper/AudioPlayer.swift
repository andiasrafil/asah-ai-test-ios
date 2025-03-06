//
//  Untitled.swift
//  asahaitest
//
//  Created by Andi Asrafil on 06/03/25.
//
import SwiftUI
import AVFoundation

import Combine

import AVFoundation
import Combine

@Observable class AudioPlayer {
    // MARK: - Properties
    private var player = AVQueuePlayer()
    private var playerObservers = Set<AnyCancellable>()
    private var notificationObservers = [NSObjectProtocol]()
    
    var tracks: [URL] = []
    var currentTrackIndex: Int = -1
    var isPlaying: Bool = false
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var showToast: Bool = false
    
    deinit {
        cleanup()
    }
    
    private func cleanup() {
        // Remove all observers
        playerObservers.forEach { $0.cancel() }
        playerObservers.removeAll()
        
        notificationObservers.forEach { NotificationCenter.default.removeObserver($0) }
        notificationObservers.removeAll()
        
        player.pause()
        player.removeAllItems()
    }
    
    // MARK: - Public Methods
    func loadTrack(url: URL) {
        isLoading = true
        errorMessage = nil
        
        // Cancel existing observers
        playerObservers.forEach { $0.cancel() }
        playerObservers.removeAll()
        
        // Create new player item with AVURLAsset instead of AVAsset(url:)
        let asset = AVURLAsset(url: url)
        
        // Use modern async/await pattern for iOS 16+
        Task {
            do {
                // Load the "playable" property using the modern method
                let playable = try await asset.load(.isPlayable)
                
                // Return to the main thread for UI updates
                await MainActor.run {
                    if playable {
                        // Asset is playable, create player item
                        let playerItem = AVPlayerItem(asset: asset)
                        
                        // Observe player item status
                        playerItem.publisher(for: \.status)
                            .receive(on: RunLoop.main)
                            .sink { [weak self] status in
                                guard let self = self else { return }
                                self.isLoading = false
                                switch status {
                                case .readyToPlay:
                                    self.errorMessage = nil
                                case .failed:
                                    self.errorMessage = playerItem.error?.localizedDescription ?? "Failed to load track"
                                    self.isPlaying = false
                                    self.showToast = true
                                case .unknown:
                                    // Still loading or indeterminate
                                    break
                                @unknown default:
                                    break
                                }
                            }
                            .store(in: &self.playerObservers)
                        
                        // Replace current player item
                        self.player.replaceCurrentItem(with: playerItem)
                    } else {
                        self.isLoading = false
                        self.errorMessage = "Asset is not playable"
                        self.isPlaying = false
                        self.showToast = true
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.isPlaying = false
                    self.showToast = true
                }
            }
        }
    }
    
    func play(url: URL) {
        guard !isPlaying else { return }
        
        cleanup()
        registerForEndOfPlaybackNotification { [weak self] in
            self?.isPlaying = false
        }
        
        loadTrack(url: url)
        player.play()
        isPlaying = true
    }
    
    func play(urls: [URL]) {
        guard !isPlaying && !urls.isEmpty else { return }
        
        cleanup()
        tracks = urls
        
        registerForEndOfPlaybackNotification { [weak self] in
            guard let self = self else { return }
            self.isPlaying = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.playRandomTrack()
            }
        }
        
        playRandomTrack()
    }
    
    func playRandomTrack() {
        guard !tracks.isEmpty else { return }
        
        let randomIndex = Int.random(in: 0..<tracks.count)
        currentTrackIndex = randomIndex
        let randomURL = tracks[randomIndex]
        
        loadTrack(url: randomURL)
        
        // Add a delay to ensure the track is loaded before playing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            // Double check if the track is ready
            if self.player.currentItem?.status == .readyToPlay {
                self.player.play()
                self.isPlaying = true
            } else {
                // If not ready, retry after a delay or handle error
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    if self?.player.currentItem?.status == .readyToPlay {
                        self?.player.play()
                        self?.isPlaying = true
                    } else {
                        // Give up after second attempt
                        self?.errorMessage = "Could not play track after multiple attempts"
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func registerForEndOfPlaybackNotification(completion: @escaping () -> Void) {
        // Remove any existing observers
        notificationObservers.forEach { NotificationCenter.default.removeObserver($0) }
        notificationObservers.removeAll()
        
        // Add new observer
        let observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self,
                  let playerItem = notification.object as? AVPlayerItem,
                  playerItem == self.player.currentItem else {
                return
            }
            completion()
        }
        
        notificationObservers.append(observer)
    }
}
