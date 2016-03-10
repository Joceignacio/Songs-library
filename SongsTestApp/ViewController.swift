//
//  ViewController.swift
//  SongsTestApp
//
//  Created by Joce on 09.03.16.
//  Copyright © 2016 Joce. All rights reserved.
//

import UIKit
import CoreData
//import QuartzCore

let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

let context: NSManagedObjectContext = appDel.managedObjectContext

let request = NSFetchRequest(entityName: "Songs")



class ViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var noSongsLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refresher : UIRefreshControl!
    
    func refresh (){
        
        print("refreshed")
        
        getJSON()

        
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("reloadData"), userInfo: nil, repeats: false)
        
        
        refresher.endRefreshing()
        
    }
    
    
    func reloadData(){
        
        collectionView.reloadData()
    }
    
    @IBAction func printDBClick(sender: AnyObject) {
        
       
        do { let results = try context.executeFetchRequest(request)
            
            print("results.count = \(results.count)")
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    print("author is \(result.valueForKey("author")!)")
                    print("id is \(result.valueForKey("id")!)")
                    print("label is \(result.valueForKey("label")!)")
                    print("-------")
                    
                }
            }
            
            
            
        }
        catch{
            
            print(error)
            
        }
        
    }
    
   
    @IBAction func refreshClick(sender: AnyObject) {

        
    }
   
    func getJSON(){
        
        let url = NSURL(string: "http://tomcat.kilograpp.com/songs/api/songs")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            if let urlContent = data {
                
                do {
                    
                    let jsonSongs = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                  
                    do { let results = try context.executeFetchRequest(request)
                        
                        
                        if results.count > 0 {
                            
                            for result in results as! [NSManagedObject]{
                                print(result.valueForKey("id")! as! Int)
                                context.deleteObject(result)
                                
                            }
                        }
                        
                    }
                    catch{
                        
                        print(error)
                        
                    }
                    
                    for (var i=0 ; i < jsonSongs.count ; i++) {
                        
                        let newSong = NSEntityDescription.insertNewObjectForEntityForName("Songs", inManagedObjectContext: context)
                        
                        newSong.setValue(jsonSongs[i]["author"], forKey: "author")
                        
                        newSong.setValue(jsonSongs[i]["id"], forKey: "id")
                        
                        newSong.setValue(jsonSongs[i]["label"], forKey: "label")
                        
                        do {
                            try context.save()
                        }
                        catch{ print(error)
                            }
                        }
                    
                }
                catch {
                    
                    print(error)
                    
                }
                
            }
        }
        
        task.resume()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        do { let results = try context.executeFetchRequest(request)
        
            if results.count>0{
            
                noSongsLabel.hidden = true
                
                return Int(results.count)
            }
            else {
                
                noSongsLabel.hidden = false
                
                return 0
            }
        }
        catch{
            
            print(error)
            
            return 0
        }
        
        
    }
    
    func collectionView (collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        do { let results = try context.executeFetchRequest(request)
            
            cell.labelSong.text = results[indexPath.row].valueForKey("label")! as? String
            
            cell.authorSong.text = results[indexPath.row].valueForKey("author")! as? String
            
            
            
            
        }
        catch{
            
            print(error)
            
        }
        
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        cell.layer.borderWidth = 1
        
        return cell
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.collectionView?.addSubview(refresher)
        
        request.returnsObjectsAsFaults = false
        
        getJSON()
        
        
        
     
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

