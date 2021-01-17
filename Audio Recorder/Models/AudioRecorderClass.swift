import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    
    override init() {
        super.init()
        fetchRecordings()
    }
    
    // To notify observing views about changes, for example when the recording is started, we need a PassthroughObject.
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    // Initialize an AVAudioRecorder instance within our AudioRecorder. With its help we will start the recording sessions later.
    var audioRecorder: AVAudioRecorder!
    
    // Create an array to hold the recordings
    var recordings = [Recording]()
    
    /* AudioRecorder class should pay attention to whether something is being recorded or not.
     For this purpose, we use a suitable variable.
     If this variable is changed, for example when the recording is finished, we update subscribing views using our objectWillChange property.*/
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        
        // Within this function we first create a recording session using AVFoundation framework
        let recordingSession = AVAudioSession.sharedInstance()
        
        /* Define the type for our recording session and activate it.
         If this fails, we’ll output a corresponding error.*/
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        // Specify the location where the recording should be saved.
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // The file should be named after the date and time of the recording and have the .m4a format.
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        
        // define some settings for our recording
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        /* start the recording with our audioRecorder property!
         Then we inform our ContentView that the recording is running so that it can update itself and display the stop button instead of the start button. */
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            
            recording = true
            print("audioRecorder start recording")
        } catch {
            print("Could not start recording")
        }
        
    }
    
    // Stop the recording session of our AudioRecorder and inform all observing views about this by setting the recording variable to false again.
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        
        fetchRecordings()
    }
    
    // Access the stored recordings.
    func fetchRecordings() {
        
        // Empty our recordings array before to avoid that recordings are displayed multiple times.
        recordings.removeAll()
        
        
        // Access the documents folder where the audio files are located and cycle through all of them.
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            recordings.append(recording)
        }
        
        // Sort the recordings array by the creation date of its items
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        // Update all observing views, especially our RecordingsList.
        objectWillChange.send(self)
        
    }
    
    
    
}
