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
    func didPauseRecording()
}

final class Bard: NSObject {

    var isListening: Bool = false

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
        isListening = true
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

    func stopRecognition() {
        stopRecording()
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
        if (secondsOfSilence > TimeInterval(speechInterval) && candidateText != "") {
            delegate?.didFinishStorytelling(text: tokenizedSentence(candidateText))
            candidateText = ""
            pauseRecording()
        }
    }

    private func pauseRecording() {
        request.endAudio()
        speechTimer.invalidate()
        recognitionTask?.cancel()
        delegate?.didPauseRecording()
    }

    private func stopRecording() {
        isListening = false
        audioEngine.stop()
        speechTimer.invalidate()
        request.endAudio()
        recognitionTask?.cancel()
        delegate?.didEndRecording()
    }

    private func tokenizedSentence(_ sentence: String) -> String {
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
        let schemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "pt")
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
        tagger.string = sentence

        var expectedWords = ""
        let range = NSMakeRange(0, sentence.count)
        tagger.enumerateTags(in: range, scheme: .nameTypeOrLexicalClass, options: options) { (tag, tokenRange, _, _) in
            guard let tag = tag else { return }
            let token = (sentence as NSString).substring(with: tokenRange)
            switch tag {
                case .noun,
                     .verb,
                     .adjective,
                     .number,
                     .personalName,
                     .organizationName,
                     .placeName:
                     expectedWords += " \(token)"
                default: break;
            }
        }
        return expectedWords
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

