//
//  BucketListTableViewController.swift
//  MyHomey
//
//  Created by Raihana Souleymane on 7/12/16.
//  Copyright © 2016 MyHomey. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FBSDKLoginKit


class BucketListTableViewController: UITableViewController  {
    var facebookToken: String!
    let userDefaults = UserDefaults.standard
    var cache:NSCache<AnyObject, AnyObject>!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    
    var theArticle = [Article]()
    var theStory = [Article]()
    
       override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        //ActivityIndicator.hideActivityIndicatorView(self.view)
      
        self.tableView.reloadData()
    
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
//        

        
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
           }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.tableView.separatorColor = UIColor.clear
        self.tableView.separatorStyle = .none
        self.cache = NSCache()
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
       // self.tableView.allowsSelection = false
        
        self.reloadData()
        self.refreshControl?.addTarget(self, action: #selector(BucketListTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
    
           }
    
  
    func handleRefresh(refreshControl: UIRefreshControl) {
         self.reloadData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
           }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
    }
    
    func reloadData(){
        self.facebookToken = userDefaults.object(forKey: "facebookToken") as? String
         ABActivity.showActivityIndicator(self.view, text: "")
        if self.facebookToken != nil {
            
            
             if FBSDKAccessToken.current().hasGranted("publish_actions") {
                
                FBSDKGraphRequest.init(graphPath: "1809970652624352/feed?fields=place,message,likes,created_time,object_id,picture,full_picture,from", parameters: [:], httpMethod: "GET").start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        print ("result",result!)
                        
                        
                        if let response = result as? NSDictionary{
                          if let theData = response.object(forKey:"data") as? NSArray {
                           
                            self.theArticle.removeAll()
                            self.theStory.removeAll()
                            for resp in theData {
                                if (resp as!NSDictionary).object(forKey: "message") != nil
                                {
                                let myresp = Article(JSON :resp as! NSDictionary)
                                self.theArticle.append(myresp)
                                }
                                else {
                                if (resp as!NSDictionary).object(forKey: "story") != nil
                                {
                                    let myresp = Article(JSON :resp as! NSDictionary)
                                    self.theStory.append(myresp)
                                }
                                }
                            }
                            //self.theArticle.append(Article(JSON :theData[0] as AnyObject))
                        }
                      
                            //print ("theArticle",self.theArticle.count, self.theArticle[0].message as String!,self.theArticle[0].object_id as String!, self.theArticle[0].likeData!.count)
                            
                          //  print ("theStory",self.theStory.count, self.theStory[0].story as String!)
                            

                            
                            DispatchQueue.main.async( execute: {
                                self.tableView.reloadData()
                                
                              

                            })
                         

                        
                    }
                    }
                })
                
                
                
                
                

            }
           
            ABActivity.hideActivityIndicator(self.view)
            
        }
        else {
            self.theArticle = []
            self.tableView.reloadData()
            ABActivity.hideActivityIndicator(self.view)
        }
            }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.theArticle.count
            //propArray.count
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "details", sender: self)
        
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 150.0
    }
//     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    print("don't do anything")
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt IndexPath: IndexPath) -> UITableViewCell {
        //print("the action is:", self.action)
        let cell = tableView.dequeueReusableCell( withIdentifier: "BucketListcell", for: IndexPath) as! BucketListcell
        
         cell.mainView.layer.masksToBounds = true
//         cell.mainView.layer.shadowColor = UIColor.clear.cgColor
//         cell.mainView.layer.shadowOpacity = 0.2
//         cell.mainView.layer.shadowOffset = CGSize(width: 3, height: 3)
//         cell.mainView.layer.shadowRadius = 05
//        
//         cell.mainView.layer.shadowPath = UIBezierPath(rect: cell.mainView.bounds).cgPath
//         cell.mainView.layer.shouldRasterize = true
//        
          cell.mainView.layer.cornerRadius = 0
          cell.mainView.layer.borderWidth = 1
          cell.mainView.layer.borderColor = UIColor.gray.cgColor
        
        
         //cell.itemIndexPath = IndexPath
        
//        let bgColorView = UIView()
//        //bgColorView.backgroundColor = UIColor.clearColor()
//        bgColorView.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
//        cell.selectedBackgroundView = bgColorView

        
    cell.theText.text = self.theArticle[IndexPath.row].message
    cell.name.text = ((self.theArticle[IndexPath.row].publisher! as NSDictionary).object(forKey:"name") as! String!)
    cell.titleLbl.text = self.theArticle[IndexPath.row].articleTitle
        
        //set the date format
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.medium
                //formatter.dateStyle = NSDateFormatterStyle.FullStyle
                formatter.timeStyle = .none
        
                let date = dateFormatter.date(from: String(("\(self.theArticle[IndexPath.row].created_time!)").characters.prefix(10)))
        
                //print (("\(propArray[indexPath.row].statuschangedate!)"))
        
                let dateString = formatter.string(from: date!)
        
                cell.dateUpload.text = " \(dateString)"
        if (self.theArticle[IndexPath.row].likes) != nil{
     cell.likes.text = "\(self.theArticle[IndexPath.row].likeData!.count)"
        }
        else{
              cell.likes.text = "0"
            
        }

        if self.theArticle[IndexPath.row].full_picture != nil {
//        let url = URL(string: self.theArticle[IndexPath.row].full_picture!)
//        
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            DispatchQueue.main.async {
//                cell.theImage.image = UIImage(data: data!)
//            }
//        }
//        
//        
//        }
        
        
        if (self.cache.object(forKey: (IndexPath as NSIndexPath).row as AnyObject) != nil){
                print("Cached image used, no need to download it")
            cell.theImage?.image = self.cache.object(forKey: (IndexPath as NSIndexPath).row as AnyObject) as? UIImage
        }
        else{
            /**
             * ... if image dosnt exist in the cache, download it using NSURSession providing the url, display it, and store to the cahe ...
             */
            
            let artworkUrl = self.theArticle[IndexPath.row].full_picture!
            let url:URL! = URL(string: artworkUrl)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        // Before we assign the image, check whether the current cell is visible
                        //if let updateCell = tableView.cellForRow(at: IndexPath) {
                            let img:UIImage! = UIImage(data: data)
                            //updateCell.imageView?.image = img
                            cell.theImage.image = img
                            self.cache.setObject(img, forKey: (IndexPath as NSIndexPath).row as AnyObject)
                        //}
                    })
                }
            })
            task.resume()
        }
        }
        // uncomment this line if not using NSCache
        //cell.prepareForReuse()
        
        return cell
    }
    

    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //        navigationItem.backBarButtonItem?.tintColor = UIColor.blackColor()
        if segue.identifier == "details" {
            if let indexPath = tableView.indexPathForSelectedRow{
                
                
                let viewController = segue.destination as? DetailsViewController
                let selectedRow = indexPath.row
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "BucketListcell", for: indexPath) as! BucketListcell
                viewController?.theArticle = [self.theArticle[selectedRow]]
                    if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                        viewController?.myImage = self.cache.object(forKey: selectedRow as AnyObject) as? UIImage
                    }
                    else{
                        viewController?.myImage = UIImage(named: "image-unavailable")
                    }
                }
                
                
          
            
        }
        }
    }

    


class BucketListcell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var theText: UILabel!
    @IBOutlet weak var dateUpload : UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        
        theImage.image = UIImage(named: "image-unavailable.png")
        
        
    }

}
