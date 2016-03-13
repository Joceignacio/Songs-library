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


let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

let context: NSManagedObjectContext = appDel.managedObjectContext

let request = NSFetchRequest(entityName: "Songs")

class DataProvider{
    
    static let instance : DataProvider = DataProvider()
    
    var list : [songs]
    
    private init(){
        
        request.returnsObjectsAsFaults = false

        list = []
        
        do { let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    
                    let mySong : songs = songs(_id: result.valueForKey("id") as! Int,_author: result.valueForKey("author") as! String , _label: result.valueForKey("label") as! String)
                    
                    list.append(mySong)
                    
                }
                
            }
             
            else {
                JsonHelper.getJSON(true)
            
            }
            
        }
            
        catch {
            
            print(error)
            
        }
    }
    
    internal func  createDB(newlist : [songs]) -> Void{

        request.returnsObjectsAsFaults = false
        
        for song in newlist{
            
            let newSong = NSEntityDescription.insertNewObjectForEntityForName("Songs", inManagedObjectContext: context)
           
            newSong.setValue(song.id, forKey: "id")
            
            newSong.setValue(song.author, forKey: "author")
            
            newSong.setValue(song.label, forKey: "label")
            
            do{
               try context.save()
            }
            catch{
                print("error while writing data")
            }
            
        }
        
        list = newlist
        
    }
    
    internal func  updateDB(newlist : [songs]) -> Void{
       
        listToAdd = []
        
        for var i = 0; i < newlist.count ; i++ {
           
            var isNew = true
                for song in list {
                    
                    if(newlist[i].id == song.id){
                        
                        isNew = false
                        
                    }
                    
                }
                
                if(isNew == true){
                    //It's a new song we need to add it to the list
                    listToAdd.append(newlist[i])
                    
                }
                else {
                 
                }
        }
        
        indexToDel =  []
        
        for var i = 0; i < list.count ; i++ {
            
            var isDeleted = true
            
            for newSong in newlist{
            
                if(list[i].id == newSong.id){
                
                    isDeleted = false
                    }
                }
            
            if(isDeleted == true){
                
                indexToDel.append(i)
                }
            else {
                
                }
        }
        
       if (indexToDel.count > 0){
            
            }
        
    }

    
    internal func deleteOldsFromDB(){
        
        let delRequest = NSFetchRequest(entityName: "Songs")
        
        delRequest.returnsObjectsAsFaults = false
        
        for index in indexToDel {
            
            delRequest.predicate =  NSPredicate(format: "id = %@", String (list[index].id))
            
            do{
                let results = try context.executeFetchRequest(delRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        context.deleteObject(result)
                        
                    }
                }
                
                do {
                    
                    try context.save()
                    
                }
                catch{
                    
                    print("error while saving changes")
                    
                }
            }
            catch{
                
                print(error)
                
            }
        }
        
    }
    
    internal func insertNewInDB(){
        
        let insertRequest = NSFetchRequest(entityName: "Songs")
        
        insertRequest.returnsObjectsAsFaults = false
        
        for song in listToAdd {
            
            let newSong = NSEntityDescription.insertNewObjectForEntityForName("Songs", inManagedObjectContext: context)
            
            newSong.setValue(song.id, forKey: "id")
            
            newSong.setValue(song.author, forKey: "author")
            
            newSong.setValue(song.label, forKey: "label")
            
            do{
                try context.save()
            }
            catch{
                print("error while inserting new data")
            }
        }
    }
    
    

}
