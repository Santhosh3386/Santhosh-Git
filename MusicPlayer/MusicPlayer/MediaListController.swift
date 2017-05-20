//
//  MediaListController.swift
//  MusicPlayer
//
//  Created by Santhosh Kumar on 19/05/17.
//  Copyright © 2017 Santhosh Kumar. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var musicList = [MusicList]()
    var cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Songs"
        getMediaItem()
        layoutsUpdate()
        updateUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func layoutsUpdate()
    {
        self.edgesForExtendedLayout = []
        tableView.tableFooterView = UIView()
    }
    
    //Fetch  songs in apple music store
    func getMediaItem()
    {
        musicList.removeAll()
       
        musicLibraryAccess {
            guard let mediaItems = MPMediaQuery.songs().items else {
                return
            }
            
            for index in 0 ..< mediaItems.count
            {
                let item = MusicList(item: mediaItems[index])
                self.musicList.append(item)
            }
            self.updateUI()
        }

        
    }
    
    func musicLibraryAccess(andThen f:(()->())? = nil) {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            f?()
        case .notDetermined:
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        f?()
                    }
                }
            }
        case .restricted:
            print("access restricted")
            break
        case .denied:
            print("access denied")
            break
        }
    }

    func showMusicControllerPage(selectedItemIndex : Int)
    {
        let view = StoryboardHelpers.shared.getMusicControllerInstance()
        view.selecteedItemIndex = selectedItemIndex
        view.musicList = musicList
        let nav = UINavigationController(rootViewController: view)
        self.present(nav, animated: true, completion: nil)
    }
    
    func updateUI()
    {
        if tableView.delegate == nil || tableView.delegate == nil
        {
            tableView.dataSource = self
            tableView.delegate = self
        }
        tableView.reloadData()
    }
    
}

//MARK: - Tableview Datasource and Delegate

extension MediaListController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if musicList.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No musics found."
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.selectionStyle = .none
        cell.textLabel?.text = musicList[indexPath.row].title
        cell.detailTextLabel?.text = musicList[indexPath.row].artist
        
        guard let image = musicList[indexPath.row].image  else{
            cell.imageView?.image = UIImage(named: "music")
           return cell

        }
        cell.imageView?.image = image

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showMusicControllerPage(selectedItemIndex: indexPath.row)
    }
}
