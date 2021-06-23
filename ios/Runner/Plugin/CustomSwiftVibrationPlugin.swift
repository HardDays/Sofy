import AudioToolbox
import CoreHaptics
import Flutter
import UIKit

@available(iOS 13.0, *)
public class CustomSwiftVibrationPlugin: NSObject, FlutterPlugin {
    private let isDevice = TARGET_OS_SIMULATOR == 0

    public static var engine: CHHapticEngine!

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vibration", binaryMessenger: registrar.messenger())
        let instance = CustomSwiftVibrationPlugin()

        CustomSwiftVibrationPlugin.createEngine()

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    /// - Tag: CreateEngine
    public static func createEngine() {
        // Create and configure a haptic engine.
        do {
            CustomSwiftVibrationPlugin.engine = try CHHapticEngine()
        } catch {
            print("Engine creation error: \(error)")
            return
        }

        if CustomSwiftVibrationPlugin.engine == nil {
            print("Failed to create engine!")
        }

        // The stopped handler alerts you of engine stoppage due to external causes.
        CustomSwiftVibrationPlugin.engine.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")

            switch reason {
            case .audioSessionInterrupt: print("Audio session interrupt")
            case .applicationSuspended: print("Application suspended")
            case .idleTimeout: print("Idle timeout")
            case .systemError: print("System error")
            case .notifyWhenFinished: print("Playback finished")
            @unknown default:
                print("Unknown error")
            }
        }

        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        CustomSwiftVibrationPlugin.engine.resetHandler = {
            // Try restarting the engine.
            print("The engine reset --> Restarting now!")

            do {
                try CustomSwiftVibrationPlugin.engine.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }

    private func supportsHaptics() -> Bool {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "hasVibrator":
            result(isDevice)
        case "hasAmplitudeControl":
            result(isDevice)
        case "hasCustomVibrationsSupport":
            result(supportsHaptics())
        case "systemVibrate":
            AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
            result(isDevice)
        case "vibrate":
            guard let args = call.arguments else {
                result(isDevice)
                return
            }
            
            guard let myArgs = args as? [String: Any] else {
                AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
                result(isDevice)
                return
            }
            
            guard let pattern = myArgs["pattern"] as? [Int] else {
                AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
                result(isDevice)
                return
            }

            if !supportsHaptics() {
                AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
                result(isDevice)
                return
            }
            
            var hapticEvents: [CHHapticEvent]

            if pattern.count == 0 {
                hapticEvents = self.createSingleVibrationEvent(myArgs)
            } else {
                hapticEvents = self.createPatternVibrationEvent(myArgs)
            }
            // Try to play engine
            do {
                if let engine = CustomSwiftVibrationPlugin.engine {
                    let patternToPlay = try CHHapticPattern(events: hapticEvents, parameters: [])
                    let player = try engine.makePlayer(with: patternToPlay)
                    try engine.start()
                    try player.start(atTime: 0)
                }
            } catch {
                print("Failed to play pattern: \(error.localizedDescription).")
            }

            result(isDevice)
        case "cancel":
            if let engine = CustomSwiftVibrationPlugin.engine {
                engine.stop(completionHandler: nil)
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    
    private func createSingleVibrationEvent(_ args: [String: Any]) -> [CHHapticEvent] {
        var hapticEvents: [CHHapticEvent] = []

        // Get event parameters, if any
        var params: [CHHapticEventParameter] = []

        if let amplitude = args["amplitude"] as? Int {
            if amplitude > 0 {
                let p = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(Double(amplitude) / 255.0))
                params.append(p)
            }
        }

        if let duration = args["duration"] as? Int {
            // Create haptic event
            let e = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters:params,
                relativeTime:0,
                duration: Double(duration)/1000.0
            )
            hapticEvents.append(e)
        }
        
        return hapticEvents
    }
    
    private func createPatternVibrationEvent(_ args: [String: Any]) -> [CHHapticEvent] {
        var hapticEvents: [CHHapticEvent] = []
        guard let pattern = args["pattern"] as? [Int] else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return hapticEvents
        }
        assert(pattern.count % 2 == 0, "Pattern must have even number of elements!")
        
        // Get event parameters, if any
        var params: [CHHapticEventParameter] = []

        if let amplitudes = args["intensities"] as? [Int] {
            if amplitudes.count > 0 {
                // There should be half as many amplitudes as pattern
                // i.e. disregard all the wait times
                assert(amplitudes.count == pattern.count / 2)
            }

            for a in amplitudes {
                let p = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(Double(a) / 255.0))
                params.append(p)
            }
        }

        // Create haptic events
        var i: Int = 0
        var rel: Double = 0.0

        while i < pattern.count {
            // Get intensity parameter, if any
            let j = i / 2
            let p = j < params.count ? [params[j]] : []

            // Get wait time and duration
            let waitTime = Double(pattern[i]) / 1000.0
            let duration = Double(pattern[i + 1]) / 1000.0

            rel += waitTime
            i += 2

            // Create haptic event
            let e = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: p,
                relativeTime: rel,
                duration: duration
            )

            hapticEvents.append(e)

            // Add duration to relative time
            rel += duration
        }
        
        return hapticEvents
    }
}
