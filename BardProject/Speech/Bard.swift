//
//  Bard.swift
//  SpeechRecognizerDemo
//
//  Created by Carlos Corrêa on 02/12/17.
//  Copyright © 2017 Appcelerator. All rights reserved.
//

import Foundation
import Speech
import AVKit

protocol BardDelegate: class {
    func didFinishStorytelling(text: String)
    func recognizedSpeech(text: String)
    func didStartRecording()
    func didEndRecording()
}

final class Bard: NSObject {

    weak var delegate: BardDelegate?
    private var speechInterval: TimeInterval = 2
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var lastRecognizedDate = Date()
    private var speechTimer: Timer!
    private var languageIdentifier: String!
    private var candidateText = "" {
        didSet {
            lastRecognizedDate = Date()
        }
    }

    init(with speechInterval: TimeInterval, languageIdentifier: String) {
        self.speechInterval = speechInterval
        self.languageIdentifier = languageIdentifier
        super.init()
        setupAudioEngine()
    }

    private func setupAudioEngine() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }

        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageIdentifier))
        speechRecognizer?.delegate = self
    }

    func startRecognition() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    break
                default:
                    print(authStatus)
                }
            }
        }
        try? startRecording()
    }

    func startRecording() throws {
        audioEngine.prepare()
        try audioEngine.start()

        startSpeechTimer()
        delegate?.didStartRecording()

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
            if let result = result {
                let resultText = result.bestTranscription.formattedString.lowercased()
                guard resultText.isEmpty == false else { return }
                self?.delegate?.recognizedSpeech(text: resultText)
                self?.candidateText = resultText
            }
        }
    }

    private func startSpeechTimer() {
        speechTimer = Timer.scheduledTimer(timeInterval: speechInterval, target: self, selector: #selector(stillTalkingCheck), userInfo: nil, repeats: true)
    }

    @objc private func stillTalkingCheck() {
        let currentDate = Date()
        let secondsOfSilence = currentDate.timeIntervalSince(lastRecognizedDate)
        if (secondsOfSilence > TimeInterval(speechInterval)) {
            stopRecording()
            delegate?.didFinishStorytelling(text: candidateText)
        }
    }

    private func stopRecording() {
        audioEngine.stop()
        request.endAudio()
        speechTimer.invalidate()
        delegate?.didEndRecording()
    }
}

extension Bard: SFSpeechRecognizerDelegate, SFSpeechRecognitionTaskDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print("SpeechRecognizer available: \(available)")
    }

    func speechRecognitionDidDetectSpeech(_ task: SFSpeechRecognitionTask) {
        print("speechRecognitionDidDetectSpeech")
    }

    func speechRecognitionTaskFinishedReadingAudio(_ task: SFSpeechRecognitionTask) {
        print("speechRecognitionTaskFinishedReadingAudio")
    }

    func speechRecognitionTaskWasCancelled(_ task: SFSpeechRecognitionTask) {
        print("speechRecognitionTaskWasCancelled")
    }

    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
        print("didFinishSuccessfully")
    }

    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didRecord audioPCMBuffer: AVAudioPCMBuffer) {
        print("didRecord")
    }

    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didHypothesizeTranscription transcription: SFTranscription) {
        print("didHypothesizeTranscription")
    }

    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        print("didFinishRecognition")
    }
}

