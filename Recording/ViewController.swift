//
//  ViewController.swift
//  Recording
//
//  Created by TanakaShunichi on 2016/04/16.
//  Copyright © 2016年 shunichi.tanaka. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, GIDSignInUIDelegate , AVAudioRecorderDelegate{
    var audioRecorder: AVAudioRecorder?
    // 録音用URLを設定
    var dirURL :NSURL?
    var fileName = "recording.caf"
    var recordingsURL :NSURL?

    @IBAction func recordButton(sender: AnyObject) {
        let duration  = NSTimeInterval.init(5.0)
          audioRecorder!.recordForDuration(duration)
    }
    func setupAudioRecorder() {
        /// 録音可能カテゴリに設定する
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch  {
            // エラー処理
            fatalError("カテゴリ設定失敗")
        }
        
        // sessionのアクティブ化
        do {
            try session.setActive(true)
        } catch {
            // audio session有効化失敗時の処理
            // (ここではエラーとして停止している）
            fatalError("session有効化失敗")
        }

        // 録音用URLを設定
        //dirURL = documentsDirectoryURL()
        dirURL = NSURL(fileURLWithPath: "/Users/tanakashunichi/Documents")
        fileName = "recording.caf"
        recordingsURL = dirURL!.URLByAppendingPathComponent(fileName)
        
        // 録音設定

        
        let recordSettings = [AVSampleRateKey : NSNumber(float: Float(16000.0)),
                              AVFormatIDKey : NSNumber(int: Int32(kAudioFormatLinearPCM)),
                              AVNumberOfChannelsKey : NSNumber(int: 1),
                              AVEncoderBitRateKey: 16,
                              AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
        do {
            audioRecorder = try AVAudioRecorder(URL: recordingsURL!, settings: recordSettings)
            audioRecorder!.delegate = self
            audioRecorder!.prepareToRecord()
            audioRecorder!.recordForDuration(5.0)
        } catch {
            audioRecorder = nil
        }
        
   
    
    }
    
    /// DocumentsのURLを取得
    func documentsDirectoryURL() -> NSURL {
    let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
    
    if urls.isEmpty {
    //
    fatalError("URLs for directory are empty.")
    }
    
    return urls[0]
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        setupAudioRecorder()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func finishRecording(success success: Bool) {}
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("finished recording \(flag)")
            //stopButton.enabled = false
            //playButton.enabled = true
            //recordButton.setTitle("Record", forState:.Normal)
        
            // ios8 and later
            let alert = UIAlertController(title: "Recorder",
                                      message: "Finished Recording",
                                      preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Keep", style: .Default, handler: {action in
                print("keep was tapped")
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {action in
                self.audioRecorder!.deleteRecording()
            }))
            self.presentViewController(alert, animated:true, completion:nil)
        }
    }
    func audioRecorderEncodeErrorDidOccur(audioRecorder: AVAudioRecorder,
                                          error: NSError?) {
        print("\(error!.localizedDescription)")
    }

}

