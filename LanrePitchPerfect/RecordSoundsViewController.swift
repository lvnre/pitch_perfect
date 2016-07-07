//
//  ViewController.swift
//  LanrePitchPerfect
//
//  Created by Lanre Akomolafe on 7/7/16.
//  Copyright © 2016 Lanre. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    //create the audio recorder
    var audioRecorder: AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startRecording(sender: AnyObject) {
        print("start recording!")
        recordLabel.text = "Recording in progress"
        recordButton.enabled = false
        stopButton.enabled = true
        
        //Create audio session and start recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        //Specify the delegate for the audio recorder
        audioRecorder.delegate = self
        
        //prepare the audio recorder
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop recording!")
        recordLabel.text = "Tap to Record"
        recordButton.enabled = true
        stopButton.enabled = false
        
        //Stop recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //Perform the segue when the audio recorder is finished recording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("done recording")
        //only perform segue if recording was successful
        if (flag) {
            print("recording successful, performing segue")
            //perform the "stopRecording" segue and throw the audio url as the sender
            //SELF!!
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("recording unsuccessful")
        }
    }
    
    //Prepare the segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            //refer to the next view controller
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            //refer to the sender, which should be the audioRecorder.url var (make sure it's an NSURL)
            let recordedAudioURL = sender as! NSURL
            //link
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

