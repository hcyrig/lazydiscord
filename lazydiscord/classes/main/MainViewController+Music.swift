//
//  MainViewController+Music.swift
//

import AppKit

import NOFoundation

extension MainViewController {
  
  @IBAction private func musicAction(_ sender: NSSwitch) {
    
    switch sender.state {
      
      case .on: startPlayMusic()
      case .off: stopPlayMusic()
        
      default: break
    }
  }

  private func startPlayMusic() {
    
    soundtrackPlayer.playWithBundle(
      resourceName: "crack-music.arcade",
      resourceType: .mp3)
  }

  private func stopPlayMusic() {
    
    soundtrackPlayer.stop()
  }
}
