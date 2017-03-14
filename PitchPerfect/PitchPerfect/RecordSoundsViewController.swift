//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Netaround Developer on 3/9/17.
//
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!

    enum RecordStatus {
        case recording, stop
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI(.stop)
    }

    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        configureUI(.recording)
        startRecording()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text = "Tap to record"
        configureUI(.stop)
        stopRecording()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: -
    // MARK: Private methods
    
    fileprivate func configureUI(_ status: RecordStatus) {
        switch status {
        case .recording:
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        case .stop:
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    
    // Setup and start recording
    fileprivate func startRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentationDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // Create dirctory if has not created
        if !FileManager.default.fileExists(atPath: dirPath) {
            do {
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            
            audioRecorder = try AVAudioRecorder(url: filePath!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: -
// MARK: RecordSoundsViewController - AVAudioRecorderDelegate

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            showAlert("Recording Disabled", message: "Recording was not successful")
        }
    }
}

