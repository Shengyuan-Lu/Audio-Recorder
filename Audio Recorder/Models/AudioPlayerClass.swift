// In this file, we import the SwiftUI, Combine and the AVFoundation framework.

import Foundation
import SwiftUI
import Combine
import AVFoundation

// We create a class called AudioPlayer which adapts the ObservableObject protocol.
class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    // we need a PassthroughObject to notify observing views about changes, especially if an audio is being played or not.
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    // Accordingly, we implement a variable isPlaying which we set to false by default.
    // If the value of the variable gets changed, we inform observing views using our objectWillChange property.
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    
    // StartPlayback accept a URL, i.e. a file path for the audio to be played.
    func startPlayback(audio: URL) {
        
        // Start by initializing a playbackSession inside this function.
        let playbackSession = AVAudioSession.sharedInstance()
        
        // Overwrite the output audio port
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        // Start playing the audio with the help of the given file path and inform the observing views about this
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
    // To stop the playback, we add the following function to our AudioPlayer:
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    // If the audio was successfully played, we set the playing properties value back to false.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            if flag {
                isPlaying = false
            }
        }
}
