//
//  ViewController.swift
//  SongsTestApp
//
//  Created by Joce on 09.03.16.
//  Copyright © 2016 Joce. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {
    
    var dataProvider : DataProvider = DataProvider.instance

    var collectionViewFlowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var noSongsLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refresher : UIRefreshControl!
    
    func refresh (){
        
        print("refreshed")
        
      //  collectionView.reloadData()
        
        refresher.endRefreshing()
    }
    
    @IBAction func printDBClick(sender: AnyObject) {
        
     dataProvider.printDB()
        
    }

    @IBAction func refreshClick(sender: AnyObject) {
        
        
        
        }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
      return  dataProvider.list.count
        
    }
    
    func collectionView (collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.labelSong.text = dataProvider.list[indexPath.row].label
            
        cell.authorSong.text =  dataProvider.list[indexPath.row].author

        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        cell.layer.borderWidth = 1
        
        cell.tag = dataProvider.list[indexPath.row].id
        
        return cell
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        JsonHelper.getJSON()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.collectionView?.addSubview(refresher)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

