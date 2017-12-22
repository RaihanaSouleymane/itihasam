//
//  Article


import Foundation
import MapKit
import FBSDKShareKit
import FBSDKLoginKit

class Article: NSObject,MKAnnotation {

    var additionalInfo: AnyObject? // To Add Addition Info on card

    var message: String?
    var created_time :String?
    var id :String?
    var story :String?
    var imageUrl :String?
    var object_id: String?
    var picture: String?
    var likes : NSDictionary?
    var likeData: NSArray?
    var publisher:NSDictionary?
    var full_picture: String?
    var articleTitle: String?

    var address: String?
    var x: String?
    var y: String?
    var location: NSDictionary?
    var latitude: NSNumber = 0.0 // = 39.208407
    var longitude: NSNumber = 0.0 // = -76.799555
    
    
    
    //Map Annotations
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String? { return "\((publisher! as NSDictionary).object(forKey:"name")!)" }
    var subtitle: String? { return "" }
   // var jsoninfo : AnyObject
    
    init(JSON : AnyObject) {
        super.init()
        //jsoninfo = JSON
        
        //print(JSON)
        
        //New feiled used in bucket action start
        
        if let value = JSON["message"] as? String {
           
            // get the longitude and latitude from the message by position
            
            let delimiter = "\n\n"
            let newstr = value
            
            var token = newstr.components(separatedBy: delimiter)
            print (token, token.count)
            if token.count > 1 {
            self.articleTitle = token.removeFirst()
            let msge = token[0]
            print ("the message:",value)
           // print("the Title:", token[1])
           // print("the whole",token[2] )
            
            self.message = msge
            let newdelimeter = ":-"
            let theString = token[token.count-1]
            print ("the Location",theString)
            var longlat = theString.components(separatedBy: newdelimeter)
            if longlat.count >= 3 {
           // print ("longlat",longlat[0], longlat[1], longlat[2])
            
                    let intLat = (longlat[1] as NSString).doubleValue
                    self.latitude = NSNumber(value:intLat)
                    //print (self.latitude,intLat)
                    let intLong = (longlat[2] as NSString).doubleValue
                self.longitude =  NSNumber(value:intLong)
                
            }
            }
            else if token.count == 1 {
                self.message = value
                self.articleTitle = " "
            }
           // print ("the location",token[0])
            
        }

        if let value = JSON["created_time"] as? String {
            self.created_time = value
        }
        
        if let value = JSON["id"] as? String {
            self.id = value
        }
        if let value = JSON["picture"] as? String {
            self.picture = value
        }
        if let value = JSON["full_picture"] as? String {
            self.full_picture = value
        }
        
        if let value = JSON["object_id"] as? String {
            self.object_id = value
        }
        
        if let value = JSON["likes"] as? NSDictionary {
            self.likes = value
            if let likedata = value.object(forKey: "data") as? NSArray{
                self.likeData = likedata
            }
        }
        if let value = JSON["from"] as? NSDictionary {
            self.publisher = value
        }
        
        
        if let value = JSON["story"] as? String {
            self.story = value
        }
        
        
        if let value = JSON["x"] as? String {
            self.x = value
        }
        else if let value = JSON["x"] as? NSNumber {
            self.x = "\(value)"
        }
        if let value = JSON["y"] as? String {
            self.y = value
        }
        else if let value = JSON["y"] as? NSNumber {
            self.y = "\(value)"
        }

        
        
        
//        if let value = JSON["location"] as? NSDictionary {
//            self.location = value
//            
//            if let lat = value.object(forKey: "latitude") as? String {
//                let intLat = (lat as NSString).doubleValue
//                self.latitude = NSNumber(value:intLat)
//                //print (self.latitude,intLat)
//                
//            }
//            else if let lat = value.object(forKey: "latitude") as? NSNumber {
//                self.latitude = lat
//                // print (self.latitude)
//                
//            }
//            
//            if let long = value.object(forKey: "longitude") as? String {
//                self.longitude = NSNumber(value:((long as NSString).doubleValue))
//            }
//            else if let long = value.object(forKey: "longitude") as? NSNumber {
//                self.longitude = long
//            }
//        
//            if(self.latitude.doubleValue != 0.0 && self.longitude.doubleValue != 0.0){
//                self.coordinate = CLLocationCoordinate2D(latitude: (self.latitude.doubleValue) , longitude: (self.longitude.doubleValue))
//            }
//        }

        if(self.latitude.doubleValue != 0.0 && self.longitude.doubleValue != 0.0){
            self.coordinate = CLLocationCoordinate2D(latitude: (self.latitude.doubleValue) , longitude: (self.longitude.doubleValue))
        }

        
    
}

}
