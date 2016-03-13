//
//  JsonHelper.swift
//  SongsTestApp
//
//  Created by Joce on 10.03.16.
//  Copyright © 2016 Joce. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class JsonHelper {

    internal static func getJSON( emptyBase : Bool ) -> Void {
        
        var newList :[songs] = []
        
        let url = NSURL(string: "http://tomcat.kilograpp.com/songs/api/songs")
        
        let urlRequest = NSURLRequest(URL: url!)
       
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            
            if (error != nil){
                
                if error?.code == -1009{
                    
                    print("connection problems")
                    
                    }
                }
            
        if let urlContent = data {
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                do {
                    let jsonSongs = try NSJSONSerialization.JSONObjectWithData(urlContent, options: NSJSONReadingOptions.MutableContainers)
                    
                    for (var i=0 ; i < jsonSongs.count ; i++) {
                        
                        let newSong  = songs(_id: jsonSongs[i]["id"] as! Int,_author: jsonSongs[i]["author"] as! String , _label: jsonSongs[i]["label"] as! String)
                        
                        newList.append(newSong)
                        
                    }
                    
                    if (emptyBase){
                        
                       DataProvider.instance.createDB(newList)
    
                    }
                    else {
                        
                        DataProvider.instance.updateDB(newList)
                    
                    }
                }
                catch {
                    
                    print(error)
                    
                }
                
            }
          
            }
        }
      
    task.resume()
   
    }
    
}