import SwiftUI
import AVFAudio
import ExolveVoiceSDK
import UIKit

class CallClientWrapper: ObservableObject, CallsDelegate {
    
    @Published private(set) var versionDescription = ""
    @Published private(set) var isCallEstablished: Bool = false

    public static var instance = CallClientWrapper()
    private var communicator: Communicator
    private var callClient: CallClient

    private var currentCall: Call? {
        let calls = callClient.getCalls()
        if let calls {
            if !calls.isEmpty {
                return calls[0]
            }
        }

        return nil
    }

    private let logtag = "CallClientWrapper:"

    private init() {
        let config = ExolveVoiceSDK.Configuration.default()
        config?.logConfiguration.logLevel = .LL_Debug
        config?.enableSipTrace = false
        config?.enableDetectCallLocation = false

        communicator = Communicator(forOutgoingCalls: config)
        callClient = communicator.callClient()

        let sdkVersionInfo : VersionInfo = communicator.getVersionInfo()
        versionDescription = "SDK ver.\(sdkVersionInfo.buildVersion) env: \((!sdkVersionInfo.environment.isEmpty) ? sdkVersionInfo.environment : "default" )"

        callClient.setCallsDelegate(self, with: DispatchQueue.main)
    }

    func register(_ login: String, _ password: String) {
    
        if login.isEmpty || password.isEmpty {
            Alert.show("Error", "No credentials")
            return
        }
        NSLog("\(logtag) register login: \(login)")
        callClient.registerUser(login, password: password)
    }

    func unregister() {
        NSLog("\(logtag) unregister")
        callClient.unregister()
    }

    func terminateCall() {
        if let currentCall {
            currentCall.terminate()
        }
    }

    func callToNumber(number: String) {
        if currentCall != nil {
            NSLog("\(logtag) call already established, will not proceed")
            return
        }

        let session = AVAudioSession.sharedInstance()
        switch (session.recordPermission) {
        case AVAudioSession.RecordPermission.undetermined:
            NSLog("\(logtag) request record permission")
            session.requestRecordPermission { [self] (granted: Bool) in
                if granted {
                    NSLog("\(logtag) call to \"\(number)\"")
                    callClient.placeCall(number)
                }
            }
            break
        case AVAudioSession.RecordPermission.granted:
            NSLog("\(logtag) call to \"\(number)\"")
            callClient.placeCall(number)
            break
        default:
            NSLog("\(logtag) no record permission")
            break
        }
    }

    private func updateCallState(_ call: Call) {
        isCallEstablished = currentCall != nil
        if !isCallEstablished {
            unregister()
        }
    }

    //MARK: calls delegate here
    internal func callNew(_ call: Call!) {
        if let call {
            NSLog("\(logtag) call new")
            updateCallState(call)
        }
    }

    internal func callConnected(_ call: Call!) {
        if let call {
            NSLog("\(logtag) call connected")
            updateCallState(call)
        }
    }

    internal func callHold(_ call: Call!) {
        if let call {
            NSLog("\(logtag) call hold")
            updateCallState(call)
        }
    }

    internal func callDisconnected(_ call: Call!) {
        if let call {
            NSLog("\(logtag) call disconnected")
            updateCallState(call)
        }
    }

    internal func callError(_ call: Call!, error: CallError, message: String) {
        NSLog("\(logtag) call error: \(error.stringValue), \(message)")
        Alert.show("Error", "\(message.isEmpty ? error.stringValue : message)")
        if let call {
            updateCallState(call)
        }
    }
    
    func callConnectionLost(_ call: Call!) {
        NSLog("\(logtag) call connection lost")
    }

    internal func call(_ call: Call!, inConference: Bool) {}

    internal func callMuted(_ call: Call!) {}

}

