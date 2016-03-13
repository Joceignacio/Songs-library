//
//  ViewController.swift
//  SongsTestApp
//
//  Created by Joce on 09.03.16.
//  Copyright © 2016 Joce. All rights reserved.
//

import UIKit
import CoreData

//global vars

var indexPaths : [NSIndexPath] = [] // indexPaths of all cells from Collectionview

var indexToDel : [Int] = []         // indexes in data list which need to delete

var listToAdd : [songs] = []        // new objects which need to insert in coredata

class ViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {
   
    var delIndexPaths : [NSIndexPath] = []
    
    @IBOutlet weak var noSongsLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Creating singleton object of DataProvider
    
    var dataProvider : DataProvider = DataProvider.instance
    
    var refresher : UIRefreshControl!
    
    
    func insertNews(){
        
        var indexPaths: [NSIndexPath] = []
        
        for s in 0..<collectionView.numberOfSections() {
            
            for i in 0..<collectionView.numberOfItemsInSection(s) {
                
                indexPaths.append(NSIndexPath(forItem: i, inSection: s))
            }
        }
        
        dataProvider.insertNewInDB()
        
        for addItem in listToAdd {
            
            let ns : songs = songs(_id: addItem.id, _author: addItem.author, _label: addItem.label)
            
            self.dataProvider.list.append(ns)
            
            var newIndexPath : [NSIndexPath] = []
            
            newIndexPath.append( NSIndexPath (forRow: indexPaths.count, inSection: 0))
            
            indexPaths.append( newIndexPath[0] )
            
            let indexPath : [NSIndexPath] = [indexPaths[indexPaths.count-1]]
            
            self.collectionView.insertItemsAtIndexPaths(indexPath)
            
        }
        
        listToAdd.removeAll()
    }
    
    func deleteOlds() {
        
        var indexPaths: [NSIndexPath] = []
        
        //getting indexpaths of all cells
        for s in 0..<collectionView.numberOfSections() {
            for i in 0..<collectionView.numberOfItemsInSection(s) {
                indexPaths.append(NSIndexPath(forItem: i, inSection: s))
            }
        }
        var sortedIndexToDel = indexToDel.sort()   // To delete from array we need to start from tail
        
        var counter : Int = sortedIndexToDel.count-1
        
        dataProvider.deleteOldsFromDB()
        
        while(counter >= 0 ){
            
            let del : Int = sortedIndexToDel[counter]
            
            self.dataProvider.list.removeAtIndex(del)
            
            let delIndexPaths : [NSIndexPath] = [indexPaths[del]]
            
            indexPaths.removeAtIndex(del)
            
            self.collectionView.deleteItemsAtIndexPaths(delIndexPaths)
            
            counter--
            
            
        }
        
        indexToDel.removeAll()
    }
    
    func refresh (){
        
       if noSongsLabel.hidden == false {
            
            noSongsLabel.hidden = true

            collectionView.reloadData()
        
            refresher.endRefreshing()
        
        
        }
        else {
        
            JsonHelper.getJSON(false)
        
            _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updater"), userInfo: nil, repeats: false)
            
        }
        
    }
    
    func updater(){
        
        if indexToDel.count>0{
            
            deleteOlds()
        
        }
        
        insertNews()
        
        refresher.endRefreshing()
        
    }
    
    
    
    //Configurating CollectionView
    
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
        
        if(dataProvider.list.count == 0){
            noSongsLabel.hidden = false
        }
        
        JsonHelper.getJSON(false)
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.collectionView?.addSubview(refresher)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

