import AVFoundation

class Player {
    var avPlayer: AVAudioPlayer?

    init?(recordingURL: URL, loop: Bool = false) {
        do {
            // Check if the file exists before attempting to initialize the player
            // This can prevent errors if the URL points to a non-existent file.
            // However, AVAudioPlayer itself handles this by throwing an error.
            // For now, we'll rely on AVAudioPlayer's error handling.

            self.avPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            
            if loop {
                self.avPlayer?.numberOfLoops = -1 // Infinite loop
            } else {
                self.avPlayer?.numberOfLoops = 0 // No loop
            }
            self.avPlayer?.prepareToPlay() // Good practice to prepare the player
        } catch {
            print("Error initializing AVAudioPlayer: \(error.localizedDescription) for URL: \(recordingURL)")
            // Return nil explicitly if initialization fails.
            // The optional initializer `init?` will automatically return nil on error if not handled,
            // but it's good to be explicit or log the error.
            return nil
        }
    }

    func play() {
        if let player = avPlayer {
            if !player.isPlaying {
                player.play()
            }
        } else {
            print("AVAudioPlayer not initialized or already deallocated.")
        }
    }

    func stop() {
        if let player = avPlayer, player.isPlaying {
            player.stop()
            // Optional: Reset the player's current time to the beginning if you want 'stop' to mean 'reset'
            // player.currentTime = 0
        }
    }

    // Optional: Add a deinit to stop the player if it's playing when the Player object is deallocated
    deinit {
        stop()
    }
}
