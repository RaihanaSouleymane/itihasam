//
//  DetailsViewController.swift
//  Itihasam
//
//  Created by Macbook on 12/30/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var theArticle = [Article]()
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextView: UITextView!
    var myImage : UIImage?
    
    
override func viewDidLoad() {
super.viewDidLoad()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.full
    //formatter.dateStyle = NSDateFormatterStyle.FullStyle
    formatter.timeStyle = .none
    
    let date = dateFormatter.date(from: String(("\(self.theArticle[0].created_time!)").characters.prefix(10)))
    
    let dateString = formatter.string(from: date!)
    
 
self.myTextView.text = "\(self.theArticle[0].articleTitle!)\n\n\(self.theArticle[0].message!)\n\nPosted by: \((self.theArticle[0].publisher!).object(forKey:"name") as! String)\nCreated_time: \(dateString)"
    if self.myImage != nil {
    self.myImageView.image = self.myImage
    }
    else{
    
if self.theArticle[0].full_picture != nil {
    let url = URL(string: self.theArticle[0].full_picture!)
    DispatchQueue.global().async {
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        DispatchQueue.main.async {
        self.myImageView.image = UIImage(data: data!)
        }
    }
}
    }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


 func createAttributedStringFrom (string1 : String ,strin2 : String, attributes1 : Dictionary<String, NSObject>, attributes2 : Dictionary<String, NSObject>) -> NSAttributedString{
    
    let fullStringNormal = (string1 + strin2) as NSString
    let attributedFullString = NSMutableAttributedString(string: fullStringNormal as String)
    
    attributedFullString.addAttributes(attributes1, range: fullStringNormal.range(of: string1))
    attributedFullString.addAttributes(attributes2, range: fullStringNormal.range(of: strin2))
    return attributedFullString
}
    
    
}
