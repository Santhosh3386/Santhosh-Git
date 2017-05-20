//
//  StoryboardHelpers.swift
//  MusicPlayer
//
//  Created by Santhosh Kumar on 20/05/17.
//  Copyright © 2017 Santhosh Kumar. All rights reserved.
//

import UIKit

class StoryboardHelpers: NSObject {
    
    static let shared = StoryboardHelpers()
    
     let storyboard = UIStoryboard(name: mainStoryborad, bundle: nil)
    
     func getMusicControllerInstance() -> MusicController
    {
        let musicController = storyboard.instantiateViewController(withIdentifier: ControllerIdentitifer.musicController) as! MusicController
        return musicController
    }

}
