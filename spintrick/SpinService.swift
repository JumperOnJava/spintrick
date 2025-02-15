import Foundation
import CoreMotion
import AVFoundation
import ActivityKit
import SpintrickWidgetExtension

class SpinService {
    private let motionManager = CMMotionManager()
    private let delta = 0.1
    
    private var player: AVAudioPlayer?
    private var comboPlayer: AVAudioPlayer?
    private var silentPlayer: AVAudioPlayer?
    
    public func spinServiceInit() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = delta
            motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: gyroUpdate)
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            print("Audio session configured for background playback.")
        } catch {
            print("Failed to set up audio session: \(error)")
        }
        
        guard let url = Bundle.main.url(forResource: "sound", withExtension: "mp3"),
              let combourl = Bundle.main.url(forResource: "combosound", withExtension: "mp3"),
              let silent = Bundle.main.url(forResource: "silent", withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            comboPlayer = try AVAudioPlayer(contentsOf: combourl)
            comboPlayer?.prepareToPlay()
            silentPlayer = try AVAudioPlayer(contentsOf: silent)
            silentPlayer?.prepareToPlay()
        } catch {
            print("Error registering sounds: \(error)")
        }
        
        do {
            let _ = try Activity<SpintrickWidgetAttributes>.request(
                attributes: SpintrickWidgetAttributes(name: "Spintrick"),
                content: ActivityContent(state: SpintrickWidgetAttributes.ContentState(emoji: ""), staleDate: Date.now.addingTimeInterval(TimeInterval(3600))),
                pushType: nil
            )
        } catch {
            print("Error displaying activity: \(error)")
        }
    }
    
    private var totalRotation = 0.0
    private var combo = 0.0
    
    private func gyroUpdate(data: CMGyroData?, error: Error?) {
        guard let data = data else { return }
        
        let rotationRate = data.rotationRate
        let nRate = (
            x: rotationRate.x * delta * 57.29,
            y: rotationRate.y * delta * 57.29,
            z: rotationRate.z * delta * 57.29
        )
        
        totalRotation += nRate.z
        
        if abs(nRate.z) < 45 {
            if combo == 0.0 {
                combo = sign(totalRotation)
            }
            if abs(totalRotation) > 270 {
                if sign(totalRotation) == combo {
                    player?.play()
                    combo = sign(totalRotation)
                } else {
                    comboPlayer?.play()
                    combo = 0
                }
                playActivity()
            }
            totalRotation = 0
        }
        silentPlayer?.play()
    }
    
    private func playActivity() {
        Activity<SpintrickWidgetAttributes>.activities.forEach { activity in
            Task {
                let contentState =  SpintrickWidgetAttributes.ContentState(emoji: "😎")
                await activity.update(ActivityContent(state: contentState,staleDate: Date.now))
            }
        }
    }
}
