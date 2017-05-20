//
//  MusicController.swift
//  MusicPlayer
//
//  Created by Santhosh Kumar on 18/05/17.
//  Copyright © 2017 Santhosh Kumar. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class MusicController: UIViewController {
    
    @IBOutlet weak var sliderBtn: UISlider!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var bg_ImageView: UIImageView!
    //Assinee Property
    var selecteedItemIndex : Int?
    var musicList = [MusicList]()

    //This Property
    var player:AVPlayer?
    var playImageName = "play"
    var pauseImageName = "pause"
    var updater : CADisplayLink! = nil

    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        layoutUpdate()
        playMusic(index: selecteedItemIndex!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func layoutUpdate()
    {
        sliderBtn.tintColor = UIColor.black
        sliderBtn.minimumValue = 0.0
        sliderBtn.value = 0.0
    }
    
    func navigation()
    {
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismiss(sender:)))
        self.navigationItem.leftBarButtonItem = cancel
    }
    
    func dismiss(sender : UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK: - Actions
    
    @IBAction func play(_ sender: UIButton) {
        
        if player?.rate == 0
        {
            player!.play()
            playBtn.setImage(UIImage(named: pauseImageName), for: .normal)
            
        } else {
            player!.pause()
            
            playBtn.setImage(UIImage(named: playImageName), for: .normal)
        }
    }

    @IBAction func next(_ sender: UIButton) {
        let index = selecteedItemIndex! + 1
        playMusic(index: index)
    }
    
    @IBAction func previous(_ sender: UIButton) {

        let index = selecteedItemIndex! - 1
        playMusic(index: index)

    }
    
    
    @IBAction func seekAction(_ sender: UISlider) {
        
        let seconds : Int64 = Int64(sender.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    /**
     play the music based on actions.
     
     if index is greater/less defaultly will paly the first index song.
     
     add the nofification for find the  song end.
     
     add timer for update the slider value.
 */
    func playMusic(index : Int)
    {
        var copyIndex = index
        if musicList.count <= index || index < 0 {
            copyIndex = 0
        }

        selecteedItemIndex = copyIndex
        
        guard let url = musicList[copyIndex].url else {
            return
        }
        
        
        let playerItem = AVPlayerItem(url:url)
        player = AVPlayer(playerItem: playerItem)

        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        sliderBtn.maximumValue = Float(seconds)
        sliderBtn.isContinuous = true
        player!.play()
        
        playBtn.setImage(UIImage(named: pauseImageName), for: .normal)
        if  musicList[copyIndex].image != nil {
            bg_ImageView.image = musicList[copyIndex].image
        }else {
            bg_ImageView.image = UIImage(named: "bg_image1")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        _ = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateMusicSlider), userInfo: nil, repeats: true)


    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        let index = selecteedItemIndex! + 1
        playMusic(index: index)
    }
    
    func updateMusicSlider(){
      let floatTime = Float(CMTimeGetSeconds((player?.currentTime())!))
      sliderBtn.value = floatTime
    }
}
//140294


