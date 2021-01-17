//
//  Audio_RecorderApp.swift
//  Audio Recorder
//
//  Created by Shengyuan Lu on 1/17/21.
//

import SwiftUI

@main
struct Audio_RecorderApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(audioRecorder: AudioRecorder())
        }
    }
}
