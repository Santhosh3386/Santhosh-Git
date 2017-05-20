//
//  MusicList.swift
//  MusicPlayer
//
//  Created by Santhosh Kumar on 20/05/17.
//  Copyright © 2017 Santhosh Kumar. All rights reserved.
//

import UIKit
import MediaPlayer


struct MusicList {
    var title : String?
    var artist : String?
    var url : URL?
    var image : UIImage?
    
    init(item : MPMediaItem) {
        title = item.title ?? "demo.mp3"
        artist = item.title ?? " "
        url = item.assetURL
        image = item.artwork?.image(at: CGSize(width: 500, height: 500))
    }
}
//class MusicList: NSObject {
//
//
//}
