//
//  BucketListTableViewController.swift
//  MyHomey
//
//  Created by Raihana Souleymane on 7/12/16.
//  Copyright © 2016 MyHomey. All rights reserved.
//

import UIKit
import Crashlytics
import Firebase
//import FirebaseDatabase
//import FirebaseAuth

class BucketListTableViewController: UITableViewController  {

    var cellIsOpen : Bool = false
    var PropertyList :[NSDictionary] = []
    var myPropertyList :[NSArray] = []
    var propertyIdTopass :String!
    var PropertyBedroomsTopass :String!
    var PropertyBathroomsTopass :String!
    var vc : ListAndMapController!
    var selectedIndices: [Int] = []
    var propertyId : [String] = []
    var likedPropData : Property?
    var likedPropArray = [Property]()
    var propData : Property?
    var propArray = [Property]()
    var action : String = ""
    var convid : String = ""
    var isSelected:Bool = false
    var IS_FROM_AGENTAPP : Bool = false
       
    
    var alertTitle : String = ""
    var singleAlertTitle: String = "Move Property"
    //var pluralAlertTitle: String = "Move Properties"
    var alertMessage = " "
    let releaseAlertMessage = "Are you sure that you would like to release this Property?"
    //let pluralReleaseAlertMessage = "Are you sure that you would like to release these Properties?"
    
    let likeAlertMessage = "Are you sure that you would like to move this Property to the Liked group?"
    //let pluralLikeAlertMessage = "Are you sure that you would like to move these Properties to the Liked group?"
    
    let declineAlertMessage = "Are you sure that you would like to move this Property to the Declined group?"
    //let pluralDeclineAlertMessage = "Are you sure that you would like to move these Properties to the Declined group?"
    
    let sentProperty = "Are you sure that you would like to send this Property?"
    //let pluralSentProperty = "Are you sure that you would like to send these Properties?"
    
    var reqShowingTitle: String = "Request a Showing"
    let reqShowingMessage = "Are you sure that you would like to request a showing for this property and move it to Request Showing group?"

    
    var actionParm = ""
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        ActivityIndicator.hideActivityIndicatorView(self.view)
       // self.reloadData(action)
        self.tableView.reloadData()
    
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        

        
        }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
       self.tableView.allowsMultipleSelectionDuringEditing = false
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.allowsSelection = false
           }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
           }
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
       
    }
    
    func reloadData(action: String,  conversationid: String){
        
        self.action = action
        self.convid = conversationid
        if self.action == "" {
            // ActivityIndicator.showActivityIndicatorView(self.view, text: "")
            self.propArray = []
            self.tableView.reloadData()
            // ActivityIndicator.hideActivityIndicatorView(self.view)
        }
        else {
            if let id = getLoginUserId(){
                    ActivityIndicator.showActivityIndicatorView(self.view, text: "")
                    WebService.sharedInstance.getBucketPropertes("\(id)", bucketType: self.action, conversationId: self.convid, success: { (json) -> Void in

                        var conversation :Conversation?
                        for conv in MessengerController.conversationArray {
                            if conv.conversationid?.stringValue == self.convid {
                                conversation = conv
                                //property.additionalInfo = ["ClientName": conv.conversationname ?? ""]
                                break
                            }
                        }
                       print("the properties",json)
                        ActivityIndicator.hideActivityIndicatorView(self.view)
                        
                        
                       // print(json)
                        
                        if let StoredGroup = json as? NSArray {
                            self.myPropertyList.append(StoredGroup)
                            self.likedPropArray.removeAll()
                            self.propArray.removeAll()
                            
                            var propArrayToBeSaveInLocal:[NSDictionary] = []
                            
                            for i in 0 ..< StoredGroup.count {
                                 let sharedPropertyBucket = SharedPropertyBucket(JSON :StoredGroup[i])
                                if let propJson = StoredGroup[i].objectForKey("property") as? NSDictionary{
                                    self.PropertyList.append(propJson)
                                    let property = Property(JSON: propJson)
                                    self.likedPropData = property
                                    self.likedPropArray.append(property)
                                    self.propData = property
                                    self.propArray.append(property)
                                    propArrayToBeSaveInLocal.append(propJson)
                                    self.propArray[i].additionalInfo = ["SharedPropertyId": sharedPropertyBucket.sharedPropertyId ?? "", "ClientName": conversation?.conversationname ?? ""]
                                    self.propArray[i].statuschangedate = (sharedPropertyBucket.updateddate)!
                                    if let sharedpropertymember = StoredGroup[i].objectForKey("sharedpropertymember") as? NSArray {
                                        for j in 0..<sharedpropertymember.count {
                                           // print ((sharedpropertymember[i].objectForKey("memberid") as? NSNumber)!)
                                            if ("\((sharedpropertymember[j].objectForKey("memberid") as? NSNumber)!)" == id ) {
                                                self.propArray[i].feedbackaction = ( "\((sharedpropertymember[j].objectForKey("feedbackaction") as? String) ?? "")")
                                                self.propArray[i].feedbackcomments = ("\((sharedpropertymember[j].objectForKey("feedbackcomments") as? String) ?? "")")
                                            }
                                        }
                                    }
                                }
                            }
                        }

                       
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.tableView.reloadData()
                        })
                       
                        }, fail: { (error) in
                   
                            ActivityIndicator.hideActivityIndicatorView(self.view)
                            Answers.logCustomEventWithName("Fail Get Property", customAttributes: ["fail" : "get"])
                    })

            }
        }
    }
    
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propArray.count
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 307
        
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
     
    }
//     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    print("don't do anything")
//    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("the action is:", self.action)
        let cell = tableView.dequeueReusableCellWithIdentifier( "BucketListcell", forIndexPath: indexPath) as! BucketListcell
        // cell.itemIndexPath = indexPath
        
        let bgColorView = UIView()
        //bgColorView.backgroundColor = UIColor.clearColor()
        bgColorView.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        cell.selectedBackgroundView = bgColorView


        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if (propArray[indexPath.row].price != "") {
            let price = " $\(numberFormatter.stringFromNumber(Int(propArray[indexPath.row].price))!)"
            cell.price!.text = price
            
        }
        else {
            cell.price!.text = (" $ \(propArray[indexPath.row].price)")
        }
        
        cell.address!.text = (" \(propArray[indexPath.row].address)")
    cell.city!.text = "\(propArray[indexPath.row].city), \(propArray[indexPath.row].state), \(propArray[indexPath.row].country)"
       // cell.noteNumber.text = ""
        

        
        if let imageUrl = NSURL(string: propArray[indexPath.row].photourl) {
            cell.propertyImageview.setImageWithURL(imageUrl)
        }
    
        cell.propertyImageview.addSubview(cell.price)
        cell.propertyImageview.addSubview(cell.address)
        cell.propertyImageview.addSubview(cell.city)
        cell.propertyImageview.addSubview(cell.providerTitle)
        cell.propertyImageview.addSubview(cell.providerName)
        //cell.propertyImageview.addSubview(cell.noteNumber)
        cell.propertyImageview.contentMode = UIViewContentMode.ScaleAspectFill
       
        //set the date format
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        //formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = .NoStyle
        
        let date = dateFormatter.dateFromString(String(("\(propArray[indexPath.row].statuschangedate!)").characters.prefix(10)))
        
        print (("\(propArray[indexPath.row].statuschangedate!)"))
        
        let dateString = formatter.stringFromDate(date!)
        
        cell.date.text = " \(dateString)"
        
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        if propArray[indexPath.row].source != "listhub" {
            cell.providerTitle?.text = " Property provided via"
           cell.providerName?.text = "\(propArray[indexPath.row].source.capitalizedString)"
        }
        else {
            cell.providerTitle?.text = " Property provided via:"
            cell.providerName?.text = " MyHomey"
        }
        if IS_FROM_AGENTAPP == true{
        }
        else {
        
        if self.action == "Liked"{
            
            cell.labelOne.text = "Share"
            cell.imageOne.image = UIImage(named: "sendIcon")
            cell.buttonOne.tag = 5
           
            cell.labelTwo.text = "Dislike"
            cell.imageTwo.image = UIImage(named: "dislikeBtn")
            cell.buttonTwo.tag = 6
            }
            

        else if self.action == "Disliked" {
            
            
            cell.labelOne.text = "Share"
            cell.imageOne.image = UIImage(named: "sendIcon")
            cell.buttonOne.tag = 5
            
            cell.labelTwo.text = "Like"
            cell.imageTwo.image = UIImage(named: "likeBtn")
            cell.buttonTwo.tag = 7
            
            }
            
        else if self.action == "Reviewed" {
            }
        if action == "Reqshowing" {
       
            cell.labelOne.text = "Remind Agent"
            cell.imageOne.image = UIImage(named: "listingProvider")
            cell.buttonOne.tag = 8
            
            cell.labelTwo.text = "No longer Interested"
            cell.imageTwo.image = UIImage(named: "listingProvider")
            cell.buttonTwo.tag = 9
        
        }
                }
        return cell
    }
    

    @IBAction func handleTapButton(sender: AnyObject) {
        
        let tappoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        
        if let indexPath = self.tableView.indexPathForRowAtPoint(tappoint) {
        
        let mySelectedCell = tableView.cellForRowAtIndexPath(indexPath) as? BucketListcell
            if mySelectedCell != nil{

                let storyboard = UIStoryboard(name: "FindProperty", bundle: nil)
                //let controller = storyboard.instantiateViewControllerWithIdentifier("PropertyCardDetail")                    as! PropertyCardViewController
                //controller.IS_DETAIL_PAGE = true
                let controller = storyboard.instantiateViewControllerWithIdentifier("SinglePropertyDetailsVC")                    as! SinglePropertyDetailsViewController
                controller.CAN_REVIEW = false
                controller.CAN_SEND = false
                let property = propArray[indexPath.row]
//                for conv in MessengerController.conversationArray {
//                    if conv.conversationid?.stringValue == convid {
//
//                        property.additionalInfo = ["ClientName": conv.conversationname ?? ""]
//                        break
//                    }
//                }
                controller.property = property
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    
   
    func notesButtonClicked(indexPath: NSIndexPath) {
        
       let prop = propArray[(indexPath.row)]
        let address = "\(prop.address), \(prop.city)"
        var propertyid = ""
        if let sharedPropertyId = prop.additionalInfo?.objectForKey("SharedPropertyId") as? String {
            propertyid = sharedPropertyId
        }
        // show propertyNotesDisplay page
        let storyboard = UIStoryboard(name: "NotesStorybord", bundle: nil)
        if let vc = storyboard.instantiateViewControllerWithIdentifier("PropertyNotesDisplay") as? PropertyNotesDisplay {
            vc.propertyAddress = address
            print(propertyid)
            vc.propertyid = propertyid
            let color = UIColor.grayColor()
            
            vc.view.backgroundColor = color.colorWithAlphaComponent(0.6)
            vc.modalPresentationStyle = UIModalPresentationStyle.Custom
            self.presentViewController(vc, animated: true, completion:nil)
            
            
        }
    }

    
    @IBAction func actionClick (sender: AnyObject) {
        
        let tappoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        if let indexPath = self.tableView.indexPathForRowAtPoint(tappoint) {
            let mySelectedCell = tableView.cellForRowAtIndexPath(indexPath) as? BucketListcell
            if mySelectedCell != nil{
                self.performAction (indexPath, senderTag: sender.tag)
                
            }
        }
        
    }

    
}

class BucketListcell: UITableViewCell {
    
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var mainView: UIView!
   
    @IBOutlet weak var bottomMargingConstraint: NSLayoutConstraint!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var providerTitle: UILabel!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var propertyImageview: UIImageView!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var tapView: UIView!
    
  
    @IBOutlet weak var botomTextLayout: NSLayoutConstraint!
    var  coverLayer : CALayer!
    
    @IBOutlet weak var viewFour: UIView!
    
    @IBOutlet weak var buttonFour: UIButton!
    
    @IBOutlet weak var labelFour: UILabel!
    
    @IBOutlet weak var imageFour: UIImageView!
   
    
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var buttonThree: UIButton!
    
    @IBOutlet weak var labelThree: UILabel!
    
    @IBOutlet weak var imageThree: UIImageView!
    
    
    @IBOutlet weak var noteView: UIView!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var buttonTwo: UIButton!
    
    @IBOutlet weak var labelTwo: UILabel!
    
    @IBOutlet weak var imageTwo: UIImageView!
    
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var buttonOne: UIButton!
    
    @IBOutlet weak var labelOne: UILabel!
    
    @IBOutlet weak var imageOne: UIImageView!
    

    
    
}