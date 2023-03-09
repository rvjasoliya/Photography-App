//
//  PlayerViewController.swift
//  Lessons
//
//  Created by iMac on 07/03/23.
//

import Foundation
import SwiftUI
import AVKit

struct PlayerViewController: UIViewControllerRepresentable {
    
    var videoURL: URL?
    let controller = AVPlayerViewController()
    
    private var player: AVPlayer {
        return AVPlayer(url: videoURL!)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        controller.modalPresentationStyle = .fullScreen
        controller.player = player
        controller.player?.play()
        return controller
    }
    
    func playVideo(){
        controller.player?.play()
    }
    
    func pauseVideo(){
        controller.player?.pause()
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {}
}

struct DeviceRotationViewModifier: ViewModifier {
    
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
    
}

// A View wrapper to make the modifier easier to use
extension View {
    
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
    
}
