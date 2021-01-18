//
//  ContentView.swift
//  Audio Recorder
//
//  Created by Shengyuan Lu on 1/17/21.
//

import SwiftUI

struct MainView: View {
    
    // The View will need to access an AudioRecorder instance, so we declare a corresponding ObservedObject.
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        NavigationView {
            VStack {
                RecordingsList(audioRecorder: audioRecorder)
                    .padding(.top, 20)
                
                /* When the audioRecorder is not recording, we want to present a button for starting the record session.
                 If this is not the case, i.e. if a recording is in progress,
                 we would like to have a button for stopping the recording instead.*/
                
                if !audioRecorder.recording {
                    Button(action: {
                        self.audioRecorder.startRecording()
                        print("Start recording")
                        
                    }) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                } else {
                    Button(action: {
                        self.audioRecorder.stopRecording()
                        print("Stop recording")
                        
                    }) {
                        Image(systemName: "stop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .foregroundColor(.red)
                            .padding(.bottom, 40)
                    }
                }
            } // End of the VStack
            .navigationBarTitle("Voice Recorder", displayMode: .large)
            .navigationBarItems(trailing: EditButton()) // Add the default edit button to the navigation bar of our ContentView.
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        // We need to initialise an AudioRecorder instance for our previews struct
        MainView(audioRecorder: AudioRecorder())
        
    }
}
