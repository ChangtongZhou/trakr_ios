//
//  ViewController.swift
//  Trackr
//
//  Created by Tianyu Ying on 7/19/16.
//  Copyright © 2016 Tianyu Ying. All rights reserved.
//

import UIKit
import MapKit

struct Track {
    var id: Int?
    var title: String?
    var memo: String?
    var latitude: Double?
    var longitude: Double?
}

class TracksViewController: UITableViewController {
    
    var tracks = [Track]()
    var userName: String?
    
    var mapDelegate: MapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tracks"
        
        refreshRecords()
    }
    
    func refreshRecords() {
        if userName == nil {
            return
        }
        
        tracks.removeAll()
        
        WebOperation.getAllRecordsByUser(userName!) {
            data, response, error in
            do {
                if let data = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    
                    if let rst = data["rst"] as? NSArray {
                        for i in 0..<rst.count {
                            let temp = rst[i] as? NSDictionary
                            let track = Track(id: temp!["id"] as? Int, title: temp!["title"] as? String, memo: temp!["memo"] as? String, latitude: temp!["latitude"] as? Double, longitude: temp!["longitude"] as? Double)
                            self.tracks.append(track)
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                    }
                }
            }
            catch {
                print("Something went wrong")
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell")!
        cell.textLabel?.text = tracks[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let track = tracks[indexPath.row]
        
        WebOperation.deleteRecord(track.id!) {
            data, response, error in
            do {
                if data != nil {
                    if let res = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        if let rst = res["rst"] as? NSDictionary {
                            if let status = rst["status"] as? String {
                                if status == "Success" {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.tracks.removeAtIndex(indexPath.row)
                                        tableView.reloadData()
                                    })
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print("Something went wrong")
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if mapDelegate != nil {
            mapDelegate?.pinOnMap(self, track: tracks[indexPath.row])
        }
    }
}

