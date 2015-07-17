//
//  ViewController.swift
//  timer
//
//  Created by 松浦 大 on 2015/07/14.
//  Copyright (c) 2015年 松浦 大. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var timerPicker: UIDatePicker!
    var timer: NSTimer = NSTimer()

    var settingTime: String = ""
    var initialTotalSeconds: Int = 0
    var currentTotalSeconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 現在設定されている時間を秒単位で取得
        //currentTotalSeconds = getCurrentSeconds(timeLabel.text!)
        //initialTotalSeconds = currentTotalSeconds
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        // ラベルを非表示
        // timeLabel.hidden = true
    }
    
    @IBAction func timerPickerAction(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var strDate = dateFormatter.stringFromDate(timerPicker.date)
        self.timeLabel.text = strDate
        
    }
    
    @IBAction func toggleTimer(sender: UIButton) {
        // self.timerPicker.hidden = true
        // self.timeLabel.hidden = false
        settingTime = self.timeLabel.text!
        var timeArray = split(settingTime, { $0 == ":" })
        var hours = timeArray[0].toInt()!
        var minutes = timeArray[1].toInt()!
        var seconds = timeArray[2].toInt()!
        var totalSeconds:Int = hours * 60 * 60 + minutes * 60 + seconds
        
        if timer.valid {
            stopTimer()
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
            sender.setTitle("Stop", forState: UIControlState.Normal)
        }
        
    }
    
    func initLabelText(){
        currentTotalSeconds = initialTotalSeconds
        timeLabel.text = changeRemainingTimeFormat(initialTotalSeconds)
    }
    
    func stopTimer(){
        timer.invalidate()
        toggleButton.setTitle("Start", forState: UIControlState.Normal)
    }
    
    func getCurrentSeconds(currentTime: String) -> Int {
        var currentTimeArray = split(currentTime, { $0 == ":"})
        var currentHours = currentTimeArray[0].toInt()!
        var currentMinutes = currentTimeArray[1].toInt()!
        var currentSeconds = currentTimeArray[2].toInt()!
        
        return currentHours * 60 * 60 + currentMinutes * 60 + currentSeconds
    }
    
    func onUpdate(timer: NSTimer){
        
        currentTotalSeconds--
        timeLabel.text = changeRemainingTimeFormat(currentTotalSeconds);
        
        if currentTotalSeconds <= 0 {
            toggleButton.setTitle("Start", forState: UIControlState.Normal)
            initLabelText()
            timer.invalidate()
            
            var alert = UIAlertView()
            alert.title = "タイマー終了"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func changeRemainingTimeFormat(seconds: Int) -> String {
        var destHours = seconds / (60 * 60);
        var destMinutes = seconds / 60;
        var destSeconds = seconds % 60;
        var desthoursStr: String = String(destHours)
        var destMinutesStr: String = (countElements(destMinutes.description) == 1) ? "0" + destMinutes.description : destMinutes.description
        var destSecondsStr: String = (countElements(destSeconds.description) == 1) ? "0" + destSeconds.description : destSeconds.description
        
        return desthoursStr + ":" + destMinutesStr + ":" + destSecondsStr
    }
    
    // リセットボタン
    @IBAction func resetTimer(sender: UIButton) {
        stopTimer()
        initLabelText()
    }
    
}

