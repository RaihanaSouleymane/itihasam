//
//  Arcticle.swift


import Foundation
import MapKit

class Arcticle: NSObject {

    var additionalInfo: AnyObject? // To Add Addition Info on card

    var acresTotal: String?
    var imageS3FileName: String?
    var latitude: NSNumber = NSNumber(value: 0.0)
    var longitude: NSNumber = NSNumber(value: 0.0)
    var lhPropertySubType: String?
    var priceSF: String?
    var landAreaSF: String?
    var imageURLs: [String] = [String]()
    
    //Additional Detail Elements
    var halfbath: NSNumber = NSNumber(value: 0)
    var listingStatus: String?
    var propertyDesc: String?
    var kitchenAndDining: [String] = []
    var interiorFeatures: [String] = []
    var buildingConstruction: [String] = []
    var exteriorFeatures: [String] = []
    var heatingAndCooling: [String] = []
    var additionalPropertyInfo: [String] = []
    var schools: [String] = []
    var utilities: [String] = []
    var elementarySchoolDistrict: String?
    var highSchoolDistrict: String?
    var MLSCityName: String?
    var area: String?
    var county: String?
    var parcelNumber: String?
    var countyId: String?
    var zoning: String?
    var listedBy: String?
    var listedByWebsite: String?
    var brokerLocation: String?
    var officePhone: String?
    var sourcePropertyId: String?
    var lotsize: String?
    var lotsizeunit: String?
    var bathrooms: String?
    var bedrooms: String?
    var livingarea: String?
    var statuschangedate :NSDate?
    var feedbackcomments :String?
    var feedbackaction : String?
  
    //additions to detailed
    var propertytype = ""
    var email = ""
    var disclaimer = ""
    
    
    //New feiled used in bucket action start
    lazy var propertyId:String = ""
    lazy var address: String = ""
    lazy var city:String = ""
    lazy var state:String = ""
    lazy var postCode:String = ""
    lazy var country:String = ""
    lazy var externalId = ""
    //lazy var sharedPropertyId = ""
    lazy var priceunit: String = "$"
   // lazy var price:NSNumber = NSNumber(integer: 0)
    lazy var photourl: String = ""
    lazy var source: String = "listhub"
    var detailurl: String?
    lazy var activeflag :Bool = true
    //New feiled used in bucket action end
    
    //Map Annotations
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String? { return "TITLE" }
    var subtitle: String? { return "Subtitle" }
    //var jsoninfo : AnyObject
    
    init(JSON : AnyObject) {
        super.init()
        //jsoninfo = JSON
        
        //print(JSON)
        
        //New feiled used in bucket action start
        
        if let value = JSON["propertyId"] as? String {
            self.propertyId = value
        }
        else if let value = JSON["propertyId"] as? NSInteger {
            self.propertyId = "\(value)"
        }
        else if let value = JSON["id"] as? String {
            self.propertyId = value
        }
        else if let value = JSON["listhubId"] as? String {
            self.propertyId = value
        }

        if let value = JSON["address"] as? String {
            self.address = value
        }
        if let value = JSON["city"] as? String {
            self.city = value
        }
        if let value = JSON["state"] as? String {
            self.state = value
        }
        if let value = JSON["zip"] as? String {
            self.postCode = value
        }
        else if let value = JSON["postcode"] as? String {
            self.postCode = value
        }
//        if let value = JSON["statuschangedate"] as? String {
//            self.statuschangedate = value
//        }

        if let value = JSON["country"] as? String {
            self.country = value
        }
        if let value = JSON["externalId"] as? String {
            self.externalId = value
        }else if let value = JSON["externalId"] as? NSNumber {
            self.externalId =  value.stringValue
        }else if let value = JSON["id"] as? String {
            self.externalId = value
        }
//        if let value = JSON["externalID"] as? String {
//            if externalId != "" && value != "" {
//                self.externalId =  value
//            }
//        }else if let value = JSON["externalID"] as? NSNumber {
//            if externalId != "" && value.stringValue != "" {
//                self.externalId =  value.stringValue
//            }
//        }
        
//        if let value = JSON["sharedPropertyID"] as? NSNumber {
//            self.sharedPropertyId =  value.stringValue
//        }
//        if let value = JSON["sharedPropertyId"] as? NSNumber {
//            self.sharedPropertyId =  value.stringValue
//        }
//        if let value = JSON["sharedPropertyId"] as? String {
//            self.sharedPropertyId =  value
//        }
//        else if let value = JSON["sharedPropertyID"] as? String {
//            self.sharedPropertyId =  value
//        }

        if let value = JSON["priceunit"] as? String {
            if value != "" { self.priceunit = value }
        }
        if let value = JSON["price"] as? NSNumber {
           // self.price = value
        }
//        else if let value = JSON["price"] as? NSString {
//            self.price =  NSNumber(integer:value.integerValue)
//        }
//        if let value = JSON["photourl"] as? String {
//            if value.containsString("http") {
//                self.photourl = value
//            }
//            else if let prefixurl = ConfigManager.sharedInstance.get(AutoConfig.URLPrefixPropertyPhoto) as? String {
//                self.photourl = prefixurl + value
//            }
//        }
//        else if let value = JSON["imageURL"] as? String {
//            if value.containsString("http") {
//                self.photourl = value
//            }
//            else if let prefixurl = ConfigManager.sharedInstance.get(AutoConfig.URLPrefixPropertyPhoto) as? String {
//                self.photourl = prefixurl + value
//            }
//        }
//        else if let URLsArray = JSON["imageURL"] as? [String] {
//            if URLsArray.first != nil {
//                self.photourl = URLsArray.first!
//            }
//        }
//        if let value = JSON["source"] as? String {
//            if value != "" {
//            self.source = value
//            }
//            
//        }
//       
//        if let value = JSON["detailurl"] as? String {
//            self.detailurl = value
//        }
//        if let value = JSON["activeflag"] as? Bool {
//            self.activeflag = value
//        }
        
        
        //New feiled used in bucket action end
        
        
        if let value = JSON["acrestotal"] as? String {
            self.acresTotal = value
        }
        
        if let value = JSON["bathrooms"] as? NSNumber {
            self.bathrooms = "\(value)"
        }
        
        if let value = JSON["bedrooms"] as? NSNumber {
            self.bedrooms = "\(value)"
        }
        
        if let value = JSON["livingarea"] as? NSNumber {
            self.livingarea = "\(value)"
        }

        
        if let value = JSON["imageS3filename"] as? String {
            self.imageS3FileName = value
        }
        
        if let value = JSON["lhPropertysubtype"] as? String {
            self.lhPropertySubType = value
        }

        if let value = JSON["pricessf"] as? String {
            self.priceSF = value
        }
        
        if let value = JSON["landareasqft"] as? String {
            self.landAreaSF = value
        }

//        if let value = JSON["latitude"] as? String {
//            self.latitude = Double(value)!
//        }
//        else if let value = JSON["latitude"] as? NSNumber {
//            self.latitude = Double(value)
//        }
//
//        if let value = JSON["longitude"] as? String {
//            self.longitude = Double(value)!
//        }
//        else if let value = JSON["longitude"] as? NSNumber {
//            self.longitude = Double(value)
//        }
//
//        if(self.latitude.doubleValue != 0.0 && self.longitude.doubleValue != 0.0){
//            self.coordinate = CLLocationCoordinate2D(latitude: self.latitude.doubleValue , longitude: self.longitude.doubleValue)
//        }
//        
//        if let URLsArray = JSON["imageURL"] as? [String] {
//            self.imageURLs = URLsArray
//        }
//        if let value = JSON["lotsize"] as? String {
//            self.lotsize = value
//        }
//        else if let value = JSON["lotsize"] as? NSNumber {
//            self.lotsize = value.stringValue
//        }
//
//        if let value = JSON["lotsizeunit"] as? String {
//            self.lotsizeunit = value
//        }
        
    }
    
    
}
