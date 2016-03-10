//
//  DataProvider.swift
//  SongsTestApp
//
//  Created by Joce on 10.03.16.
//  Copyright © 2016 Joce. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class DataProvider{
    
    static let instance : DataProvider = DataProvider()
    
    
    var list : [songs]
    
    private init(){
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Songs")

        request.returnsObjectsAsFaults = false

        list = []
        
        do { let results = try context.executeFetchRequest(request)
            
            print("results.count= \(results.count)")
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    let mySong : songs = songs(_id: result.valueForKey("id") as! Int,_author: result.valueForKey("author") as! String , _label: result.valueForKey("label") as! String)
                    
                    list.append(mySong)
                    
                }
                
            }
            
        }
            
        catch {
            
            print(error)
            
        }
    }
    
    
    internal func  updateDB(newlist : [songs]) -> Void{
        
        print("newlistDP.count = \(newlist.count)")

        
            for newSong in newlist{
                var isNew = true
                for song in list {
                    if(newSong.id == song.id){
                        isNew = false
                        
                    }
                    
                }
                if(isNew == true){
                  //  addNew(newSong)
                    print("\(newSong.label) is new")
                }
                else {
                 //   print("not new")
                    
                }
        }
        

    }
    
    internal func  printDB() {
        print("list.count = \(list.count)")
        for song in list{
            print("author is \(song.author)")
            print("id is \(song.id)")
            print("label is \(song.label)")
            print("-------")
                    
            }
        }
    
        
        


}
