//
//  ViewController.swift
//  CheerBeer
//
//  Created by CuongBeatbox on 2/2/16.
//  Copyright © 2016 CuongBeatbox. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var Open: UIBarButtonItem!
    
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var tableMembers: UITableView!
    
    @IBOutlet weak var intervalTime: UITextField!
    
    var player:AVAudioPlayer!
    
    var listMember : [PersonModel] = [PersonModel]()
    
    var kTimeoutInSeconds:NSTimeInterval = 30
    
    var timer: NSTimer?
    var progressTimer: NSTimer?
    var percentCount: Float = 0.0
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listMember.count
    }
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableMembers.dequeueReusableCellWithIdentifier("beerCell", forIndexPath: indexPath) as! MemberTableViewCell
        myCell.updateCell(listMember[indexPath.row])
        
        return myCell
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Let Drink Beer Together"
        progressBar.hidden = false
        
        // Do any additional setup after loading the view, typically from a nib.
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        var isNewGame = (UIApplication.sharedApplication().delegate as! AppDelegate).isNewGame
        if ((isNewGame) == true){
            // Remove all audio file at the first time
            deleteAllRecordings()
        }
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).isNewGame = false
        
        // Setup table members
        listMember = (UIApplication.sharedApplication().delegate as! AppDelegate).listMember
        
        tableMembers.dataSource = self
        stopBtn.enabled = false
        progressBar.hidden = true
        
    }
    override func viewWillAppear(animated: Bool) {
        
        // Setup table members
        listMember = (UIApplication.sharedApplication().delegate as! AppDelegate).listMember
        
        tableMembers.dataSource = self
        
        tableMembers.reloadData()
    }
    
    @IBAction func startGame(sender: UIButton) {
        fetch()
        progressBar.hidden = false
        // Set start button
        startBtn.setTitleColor(UIColor(red: 70, green: 70, blue: 72), forState: UIControlState.Normal)
        startBtn.setBackgroundImage(UIImage(named: "Icon-Circle-Default.png"), forState: .Normal)
        startBtn.enabled = false
        // Set stop button
        stopBtn.setTitleColor(UIColor(red: 239, green: 79, blue: 27), forState: UIControlState.Normal)
        stopBtn.setBackgroundImage(UIImage(named: "Icon-Circle-Highlight.png"), forState: UIControlState.Normal)
        stopBtn.enabled = true
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(kTimeoutInSeconds,
            target:self,
            selector:Selector("fetch"),
            userInfo:nil,
            repeats:true)
        self.progressTimer = NSTimer.scheduledTimerWithTimeInterval(1,
            target:self,
            selector:Selector("doUploadProgressBar"),
            userInfo:nil,
            repeats:true)
    }
 
    func doUploadProgressBar(){
        percentCount++
        
        var progressPercent = (percentCount / 30)
        progressBar.setProgress(progressPercent, animated: true)
        
        if percentCount == 31{
            percentCount = 0.0
            progressBar.setProgress(0.01, animated: true)
        }
        
    }
    func fetch() {
        var diceRoll = Int(arc4random_uniform(UInt32(listMember.count)))
        play(listMember[diceRoll].SoundPath)
        
        listMember[diceRoll].NumberOfBeer = listMember[diceRoll].NumberOfBeer + 1
        tableMembers.reloadData()
    }
    @IBAction func stopGame(sender: AnyObject) {
        progressBar.hidden = true
        self.timer!.invalidate()
        self.progressTimer!.invalidate()
        
        // set stop button
        stopBtn.setTitleColor(UIColor(red: 70, green: 70, blue: 72), forState: UIControlState.Normal)
        stopBtn.setBackgroundImage(UIImage(named: "Icon-Circle-Default.png"), forState: UIControlState.Normal)
        stopBtn.enabled = false
        // Set start button
        startBtn.setTitleColor(UIColor(red: 239, green: 79, blue: 27), forState: UIControlState.Normal)
        startBtn.setBackgroundImage(UIImage(named: "Icon-Circle-Highlight.png"), forState: UIControlState.Normal)
        startBtn.enabled = true
    }
    func RandomInt(min min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func play(url:NSURL) {
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    func deleteAllRecordings() {
        let docsDir =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let fileManager = NSFileManager.defaultManager()
        
        do {
            let files = try fileManager.contentsOfDirectoryAtPath(docsDir)
            var recordings = files.filter( { (name: String) -> Bool in
                return name.hasSuffix("m4a")
            })
            for var i = 0; i < recordings.count; i++ {
                let path = docsDir + "/" + recordings[i]
                
                print("removing \(path)")
                do {
                    try fileManager.removeItemAtPath(path)
                } catch let error as NSError {
                    NSLog("could not remove \(path)")
                    print(error.localizedDescription)
                }
            }
            
        } catch let error as NSError {
            print("could not get contents of directory at \(docsDir)")
            print(error.localizedDescription)
        }
        
    }
    
    }




