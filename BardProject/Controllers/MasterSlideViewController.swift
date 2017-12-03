//
//  MasterSlideViewController.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import UIKit
import WebKit

final class MasterSlideViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var imgToShow: UIImageView!
    @IBOutlet weak var buttonRecord: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var theEndView: UIView!
    @IBOutlet weak var slidesArrowView: UIView!
    @IBOutlet weak var slidesArrowImage: UIImageView!
    @IBOutlet weak var suggestionsArrowImage: UIImageView!
    @IBOutlet weak var animatedSwitch: UISwitch!
    @IBOutlet weak var drawingSwitch: UISwitch!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var txtSpeech: UITextView!
    @IBOutlet weak var lblGIF: UILabel!
    @IBOutlet weak var lblDrawing: UILabel!
    @IBOutlet weak var slidesContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestionsTrailingConstraint: NSLayoutConstraint!
    var slidesViewController: SlidesViewController!
    var suggestionsViewController: SuggestionsViewController!
    let bard = Bard(with: 0.8, languageIdentifier: "pt_BR")
    var category: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        bard.delegate = self
        webView.navigationDelegate = self
        setupGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPlayButtonUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slidesViewController?.reloadData()
    }

    private func setupPlayButtonUI() {
        buttonPlay.layer.cornerRadius = 10.0
        slidesArrowView.layer.cornerRadius = slidesArrowView.frame.width / 2
        txtSpeech.layer.cornerRadius = 10.0
    }

    private func requestImage(with text: String) {
        guard let category = category else { return }
        let request = MediaServiceRequest(text: text, animated: animatedSwitch.isOn, categoryId: category.id, realData: true)
        spinner.startAnimating()
        MediaService.getMedia(request: request) { response in
            switch response.result {
            case .success:
                guard let media = response.data, let img = media.artefacts.first else {
                    self.restartBard()
                    return
                }

                if self.drawingSwitch.isOn {
                    self.displayDrawing(candidateURL: img)
                } else {
                    UIView.animate(withDuration: 0.5) {
                        self.webView.alpha = 0
                    }
                    self.imgToShow.af_setImage(withURL: img, completion: { [weak self] resultData in
                        self?.startBardRecording()
                        if let imgView = self?.imgToShow, let imageData = resultData.data {
                            UIView.transition(with: imgView, duration: 0.8, options: .transitionCurlUp, animations: {
                                if media.animated {
                                    imgView.image = UIImage.gif(data: imageData)
                                } else {
                                    imgView.image = UIImage(data: imageData)
                                }
                                if let image = UIImage(data: imageData) {
                                    self?.slidesViewController.add(image)
                                }
                                self?.spinner.stopAnimating()
                            }, completion: nil)
                        }
                    })
                }
            case .error(message: let error):
                print(error.debugDescription)
                self.restartBard()
            }
        }
    }

    private func restartBard() {
        print("--- BARD RESTARTED ---")
        self.spinner.stopAnimating()
        self.startBardRecording()
    }

    private func displayDrawing(candidateURL: URL) {
        UIView.animate(withDuration: 0.5) {
            self.webView.alpha = 1
        }
        let finalURL = "http://ec2-54-242-167-114.compute-1.amazonaws.com/?w=\(Int(webView.frame.width/2))&h=\(Int(webView.frame.height/2))&url="+candidateURL.absoluteString.removingPercentEncoding!
        if let url = URL(string: finalURL) {
            let request = URLRequest(url: url)
            _ = webView.load(request)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        startBardRecording()
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        spinner.stopAnimating()
        startBardRecording()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        startBardRecording()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        startBardRecording()
    }

    private func startBardRecording() {
        bard.startRecognition()
    }

    private func setupGestures() {
        let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(showHistory))
        let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideHistory))
        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(showSuggestions))
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideSuggestions))
        upGesture.direction = .up
        downGesture.direction = .down
        leftGesture.direction = .left
        rightGesture.direction = .right
        view.gestureRecognizers = [upGesture, downGesture, leftGesture, rightGesture]
    }

    func shouldShowHistory(_ show: Bool) {
        slidesContainerBottomConstraint.constant = show ? 0.0 : 80.0
        animateGestures()
    }

    func shouldShowSuggestions(_ show: Bool) {
        suggestionsTrailingConstraint.constant = show ? 0.0 : 120.0
        animateGestures()
    }

    func animateGestures() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func showHistory() {
        shouldShowHistory(true)
        slidesArrowImage.image = #imageLiteral(resourceName: "arrow-down")
    }

    @objc func hideHistory() {
        shouldShowHistory(false)
        slidesArrowImage.image = #imageLiteral(resourceName: "arrow-up")
    }

    @objc func showSuggestions() {
        shouldShowSuggestions(true)
        suggestionsArrowImage.image = #imageLiteral(resourceName: "arrow-right")
    }

    @objc func hideSuggestions() {
        shouldShowSuggestions(false)
        suggestionsArrowImage.image = #imageLiteral(resourceName: "arrow")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let slidesVC = segue.destination as? SlidesViewController {
            slidesViewController = slidesVC
            slidesVC.delegate = self
        }
        if let suggestionsVC = segue.destination as? SuggestionsViewController {
            suggestionsViewController = suggestionsVC
            suggestionsVC.delegate = self
        }
    }
    @IBAction func didTouchToggleRecording(_ sender: Any) {
        if bard.isListening {
            bard.stopRecognition()
            showTheEndView()
        } else {
            startBardRecording()
            hideOverlay()
        }
    }

    private func showTheEndView() {
        UIView.animate(withDuration: 0.5) {
            self.theEndView.alpha = 1
        }
    }

    private func hideOverlay() {
        UIView.animate(withDuration: 0.5) {
            self.overlayView.alpha = 0
            self.lblGIF.isHidden = false
            self.lblDrawing.isHidden = false
            self.drawingSwitch.isHidden = false
            self.animatedSwitch.isHidden = false
        }
    }

    @IBAction func exitButtonTouched(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MasterSlideViewController: SlidesDelegate {
    func didSelectSlideImage(image: UIImage) {
        imgToShow.image = image
    }
}

extension MasterSlideViewController: BardDelegate {

    func didFinishStorytelling(text: String) {
        requestImage(with: text)
    }

    func recognizedSpeech(text: String) {
        print(text)
        txtSpeech.text = text
    }

    func didStartRecording() {
        buttonRecord.isHidden = false
        buttonRecord.setImage(#imageLiteral(resourceName: "stop-recording"), for: .normal)
    }

    func didPauseRecording() {
        print("Paused")
    }

    func didEndRecording() {
        buttonRecord.setImage(#imageLiteral(resourceName: "record-button"), for: .normal)
    }
}

extension MasterSlideViewController: SuggestionsDelegate {
    func didSelectSuggestionImage(image: UIImage) {
        imgToShow.image = image
        slidesViewController.add(image)
    }
}
