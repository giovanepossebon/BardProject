//
//  MasterSlideViewController.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import UIKit

final class MasterSlideViewController: UIViewController {

    @IBOutlet weak var imgToShow: UIImageView!
    @IBOutlet weak var buttonRecord: UIButton!

    var slidesViewController: SlidesViewController!
    let bard = Bard(with: 4.0, languageIdentifier: "pt_BR")

    override func viewDidLoad() {
        super.viewDidLoad()

        bard.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slidesViewController?.reloadData()
    }

    private func requestImage(with text: String) {
        let request = MediaServiceRequest(text: text, animated: true, categoryId: 0)
        MediaService.getMedia(request: request) { response in
            switch response.result {
            case .success:
                guard let media = response.data, let img = media.artefacts.first else { return }
                self.imgToShow.af_setImage(withURL: img)
            case .error(message: let error):
                print(error)
            }
        }
    }

    @objc private func startBardRecording() {
        bard.startRecognition()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let slidesVC = segue.destination as? SlidesViewController {
            slidesVC.delegate = self
            slidesVC.images = [#imageLiteral(resourceName: "tree1"), #imageLiteral(resourceName: "tree2"), #imageLiteral(resourceName: "tree3")]
        }
    }
    @IBAction func didTouchToggleRecording(_ sender: Any) {
        startBardRecording()
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
    }

    func didStartRecording() {
        buttonRecord.setImage(#imageLiteral(resourceName: "stop-recording"), for: .normal)
    }

    func didEndRecording() {

    }

}
