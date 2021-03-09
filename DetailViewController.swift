//
//  DetailViewController.swift
//  WorldWIKI
//
//  Created by Derek Wang on 2021-02-25.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    var wikipediaURL = "https://en.wikipedia.org/w/api.php"
    var countryDescription : String!
    var countryFlagURL : URL!
    var selectedCountry : String! {
        didSet {
            requestInfo(countryName: selectedCountry)
        }
    }
    
    //MARK: - API request method
    
    func requestInfo(countryName:String) {
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : countryName,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "500"
        ]
        
        Alamofire.request(wikipediaURL, method: .get, parameters: parameters).responseJSON { (response) in
            
            if response.result.isSuccess{
                print("Got Wikipedia info")
                print(response)
                
                let responseJSON = JSON(response.result.value!)
                
                let pageID = responseJSON["query"]["pageids"][0].stringValue
                
                self.countryDescription = responseJSON["query"]["pages"][pageID]["extract"].stringValue
                
                self.countryFlagURL = URL(string:responseJSON["query"]["pages"][pageID]["thumbnail"]["source"].stringValue)
                
                DispatchQueue.main.async {
                    self.imageView.layer.cornerRadius = 20
                    self.imageView.layer.borderWidth = 1
                    self.imageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
                    self.label.text = self.countryDescription
                    self.imageView.sd_setImage(with: self.countryFlagURL)
                }
                
            }else {
                let ac = UIAlertController(title: "There was an error...", message: "Please check your connection and try again.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(ac, animated: true, completion: nil)
                return
            }
        }
    }
}
