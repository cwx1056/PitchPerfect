//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Netaround Developer on 3/9/17.
//
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
   
    // MARK: -
    // MARK: Properties
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int { case slow = 0, fast, chipmunk, vader, echo, reverb }

    // MARK: -
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }

    // MARK: -
    // MARK: Event response
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        print("did tap playing sound")
        switch (ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
            break
        case .fast:
            playSound(rate: 1.5)
            break
        case .chipmunk:
            playSound(pitch: 1000)
            break
        case .vader:
            playSound(pitch: -1000)
            break
        case .echo:
            playSound(echo: true)
            break
        case .reverb:
            playSound(reverb: true)
            break
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopAudio()
    }

}
