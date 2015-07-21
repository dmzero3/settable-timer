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
    @IBOutlet weak var resetButton: UIButton!
    var timer: NSTimer = NSTimer()

    var settingTime: String = ""
    var initialTotalSeconds: Int = 0
    var currentTotalSeconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initSetTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(animated: Bool){
        // ラベルを非表示
        self.timeLabel.hidden = true
    }
    
    @IBAction func timerPickerAction(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var strDate = dateFormatter.stringFromDate(timerPicker.date)
        self.timeLabel.text = strDate
        
    }
    
    // Start, Stopボタン
    @IBAction func toggleTimer(sender: UIButton) {
        
        settingTime = self.timeLabel.text!
        
        switch sender.tag {
            case 0:
                currentTotalSeconds = changeTimeInSecondsFormat(settingTime, isSeconds: false)
                initialTotalSeconds = currentTotalSeconds
            case 1:
                currentTotalSeconds = changeTimeInSecondsFormat(settingTime, isSeconds: true)
                
            default:
            
            break
        }
        
        sender.tag = 1
        
        
        if timer.valid {
            stopTimer()
            
        } else {
            // self.resetButton.enabled = false;
            self.timeLabel.text = changeRemainingTimeFormat(currentTotalSeconds);
            self.timerPicker.hidden = true
            self.timeLabel.hidden = false
            

            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
            sender.setTitle("Stop", forState: UIControlState.Normal)
        }
        
    }
    
    func initSetTimer() {
        let initialSettingTime = "00:03:00"
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var date = NSDate()
        date = NSDate(timeInterval: 0, sinceDate: dateFormatter.dateFromString(initialSettingTime)!)
        
        timerPicker.date = date;
        self.timeLabel.text = initialSettingTime

    }
    
    func initLabelText(){
        currentTotalSeconds = initialTotalSeconds
        self.timeLabel.text = changeRemainingTimeFormat(initialTotalSeconds)
    }
    
    func stopTimer(){
        timer.invalidate()
        toggleButton.setTitle("Start", forState: UIControlState.Normal)
    }
    
    func changeTimeInSecondsFormat(currentTime: String, isSeconds: Bool) -> Int {
        
        var currentTimeArray = split(currentTime, { $0 == ":"})
        var currentHours = currentTimeArray[0].toInt()!
        var currentMinutes = currentTimeArray[1].toInt()!
        var currentSeconds = isSeconds ? currentTimeArray[2].toInt()! : 0
        
        return currentHours * 60 * 60 + currentMinutes * 60 + currentSeconds
    }
    
    func onUpdate(timer: NSTimer){
        
        currentTotalSeconds--
        timeLabel.text = changeRemainingTimeFormat(currentTotalSeconds);
        
        if currentTotalSeconds <= 0 {
            toggleButton.setTitle("Start", forState: UIControlState.Normal)
            initLabelText()
            timer.invalidate()
            self.timerPicker.hidden = false
            self.timeLabel.hidden = true
            
            var alert = UIAlertView()
            alert.title = "タイマー終了"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func changeRemainingTimeFormat(seconds: Int) -> String {
        var destHours = seconds / (60 * 60);
        var destMinutes = (seconds % (60 * 60)) / 60;
        var destSeconds = (seconds % (60 * 60)) % 60;
        var desthoursStr: String = String(destHours)
        var destMinutesStr: String = (countElements(destMinutes.description) == 1) ? "0" + destMinutes.description : destMinutes.description
        var destSecondsStr: String = (countElements(destSeconds.description) == 1) ? "0" + destSeconds.description : destSeconds.description
        
        return desthoursStr + ":" + destMinutesStr + ":" + destSecondsStr
    }
    
    // リセットボタン
    @IBAction func resetTimer(sender: UIButton) {
        stopTimer()
        initLabelText()
        self.timerPicker.hidden = false
        self.timeLabel.hidden = true
        toggleButton.tag = 0
        // sender.enabled = true;
    }
    
    // Value Change後にリセットボタン押下でStartタップすると値が反映されない
    // Resetボタンを押せないようにする
    
}

