import AVFoundation

class Recorder: NSObject, AVAudioRecorderDelegate { // Added NSObject and delegate conformance for future use
    var audioRecorder: AVAudioRecorder?
    let audioSession = AVAudioSession.sharedInstance()

    override init() { // Made it an override since it inherits from NSObject
        super.init()
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            // Set the category to play and record, allowing mixing with other audio,
            // defaulting to speaker, and allowing Bluetooth A2DP.
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .defaultToSpeaker, .allowBluetoothA2DP])
            try audioSession.setActive(true)
            print("Audio session configured and activated.")
        } catch {
            print("Error configuring audio session: \(error.localizedDescription)")
        }
    }

    func setupNewRecorder(url: URL) -> AVAudioRecorder? {
        let recordSettings: [String: Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleIMA4), // Apple IMA4 ADPCM
            AVSampleRateKey: 44100.0, // Standard sample rate
            AVNumberOfChannelsKey: 1, // Mono audio
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue // Medium quality
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recordSettings)
            audioRecorder?.delegate = self // Set delegate to self if you plan to implement AVAudioRecorderDelegate methods
            if audioRecorder?.prepareToRecord() == true {
                print("AVAudioRecorder prepared successfully for URL: \(url)")
            } else {
                print("AVAudioRecorder failed to prepare for URL: \(url)")
                // audioRecorder will be nil if try AVAudioRecorder fails, so this specific check might be redundant
                // if the error is caught by the catch block.
            }
        } catch {
            print("Error initializing AVAudioRecorder: \(error.localizedDescription)")
            audioRecorder = nil // Ensure audioRecorder is nil if an error occurs
        }
        return audioRecorder
    }

    // Example of a delegate method (optional, based on future needs)
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording finished successfully.")
        } else {
            print("Recording finished unsuccessfully.")
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio recorder encoding error: \(error.localizedDescription)")
        }
    }
    
    // Call this method to start recording
    func startRecording() {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                // Request permission to record if not already granted
                audioSession.requestRecordPermission { [unowned self] granted in
                    if granted {
                        DispatchQueue.main.async { // Ensure UI updates are on the main thread if any
                           if self.audioSession.recordPermission == .granted {
                                print("Recording permission granted.")
                                if recorder.record() {
                                    print("Recording started.")
                                } else {
                                    print("Failed to start recording.")
                                }
                           } else {
                                print("Recording permission was not granted after prompt.")
                           }
                        }
                    } else {
                        DispatchQueue.main.async {
                            print("Recording permission denied.")
                            // Optionally, inform the user that permission is required
                        }
                    }
                }
            } else {
                print("Already recording.")
            }
        } else {
            print("Audio recorder not initialized. Call setupNewRecorder first.")
        }
    }

    // Call this method to stop recording
    func stopRecording() {
        if let recorder = audioRecorder, recorder.isRecording {
            recorder.stop()
            print("Recording stopped.")
            // You might want to deactivate the audio session or change its category
            // if the app is not actively using recording features anymore.
            // For simplicity, this is omitted here, but consider for a full app.
        }
    }
}
