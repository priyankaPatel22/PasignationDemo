//
//  PasingVC.swift
//  PasignationDemo
//
//  Created by Pritesh Pethani on 29/07/17.
//  Copyright © 2017 Pritesh Pethani. All rights reserved.
//

import UIKit

let MainURL = "http://demo.magespider.com/doc99/api/"
let getCurrentOrderURL = "General/ArticleList"
let getCurrentOrderURLTag = 1055
let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let USERDEFAULT = UserDefaults.standard
let PAGINATION_LIMITE = 10
let Language_Type = "1"


class PasingVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableViewCurrentOrder:UITableView!
    //FOR SCROLLING VIEW
    
    
    
    var articalData = NSMutableArray()
    var articalDataGlobalData = NSMutableArray()
    
    
    
    //For Pasignation
    var pageNum:Int!
    var isLoading:Bool?
    
    
    // FIXME: - VIEW CONTROLLER METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generalViewControllerSetting()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: - OTHER METHODS
    func generalViewControllerSetting(){
        
        pageNum=1;
        let indicator1 = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator1.startAnimating()
        
        self.articalData = NSMutableArray()
        self.articalDataGlobalData = NSMutableArray()
        
        if Reachability.isConnectedToNetwork() == true {
            self.addLoadingIndicatiorOnFooterOnTableViewCurrentOrder()
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.postDataOnWebserviceForGetCurrentOrder), userInfo: nil, repeats: false)
        }else{
        }
        
        
    }
    
    
    
    func addLoadingIndicatiorOnFooterOnTableViewCurrentOrder(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        tableViewCurrentOrder.tableFooterView = spinner
    }
    
    func removeLoadingIndicatiorOnFooterOnTableViewCurrentOrder(){
        tableViewCurrentOrder.tableFooterView = nil
    }
    
    // TODO: - DELEGATE METHODS
    
    //ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == tableViewCurrentOrder {
            if isLoading == true{
                if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
                    pageNum = pageNum + 1
                    print(pageNum)
                    isLoading = false
                    
                    if Reachability.isConnectedToNetwork() == true {
                        self.addLoadingIndicatiorOnFooterOnTableViewCurrentOrder()
                        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.postDataOnWebserviceForGetCurrentOrder), userInfo: nil, repeats: false)
                    } else {
                    }
                }
            }
            
        }
    }
    
    
    //TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.articalData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "articalCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ArticalTableVC
        
        if cell == nil {
            let nib  = Bundle.main.loadNibNamed("ArticalTableVC", owner: self, options: nil)
            cell = nib?[0] as? ArticalTableVC
        }
        cell!.selectionStyle = .none;
        
        
        if let articalName =  (self.articalData[indexPath.row] as AnyObject).value(forKey: "article_name") as? String
        {
            cell?.lblArticalName.text = "\(articalName)"
        }
        
        if let categoryData =  (self.articalData[indexPath.row] as AnyObject).value(forKey: "category") as? NSArray
        {
            let catData = categoryData
            if catData.count > 0 {
                cell?.lblCategory.isHidden = false
                let mutableStirng = NSMutableString()
                
                for i in 0...catData.count - 1 {
                    if i != 0{
                        mutableStirng.append(" , ")
                    }
                    mutableStirng.append((catData.object(at: i) as AnyObject).value(forKey: "ac_name") as! String)
                }
                cell?.lblCategory.text = mutableStirng as String
                
                
                cell?.lblCategory.sizeToFit()
                
                print("CategoryFrame : ",cell?.lblCategory.frame ?? "123")
                
                cell?.lblCategory.frame = CGRect(x: (cell?.lblCategory.frame.origin.x)!, y: ((cell?.imageViewArtical.frame.origin.y)! + (cell?.imageViewArtical.frame.size.height)! + 10.0), width: (cell?.lblCategory.frame.size.width)! + 10, height: (cell?.lblCategory.frame.size.height)! + 10.0)
                cell?.lblCategory.textAlignment = .center
                cell?.lblCategory.clipsToBounds = true
                cell?.lblCategory.layer.cornerRadius = 5.0
                //(catData.object(at: 0) as AnyObject).value(forKey: "ac_name") as? String
            }
            else{
                cell?.lblCategory.isHidden = true
            }
            
        }
        else{
            cell?.lblCategory.isHidden = true
        }
        
        
        
        if let favour =  (self.articalData[indexPath.row] as AnyObject).value(forKey: "is_favourite") as? NSNumber
        {
            let favourateArtical = "\(favour)"
            if favourateArtical == "1"{
                cell?.imageViewBookmarked.image = UIImage.init(named: "bookmark_green.png")
            }
            else if favourateArtical == "0"{
                cell?.imageViewBookmarked.image = UIImage.init(named: "bookmark_gray.png")
            }
        }
        else if let favour =  (self.articalData[indexPath.row] as AnyObject).value(forKey: "is_favourite") as? String
        {
            let favourateArtical = "\(favour)"
            if favourateArtical == "1"{
                cell?.imageViewBookmarked.image = UIImage.init(named: "bookmark_green.png")
            }
            else if favourateArtical == "0"{
                cell?.imageViewBookmarked.image = UIImage.init(named: "bookmark_gray.png")
            }
        }
        
        
        cell?.btnBookMark.tag = indexPath.row
        cell?.btnShare.tag = indexPath.row
        
//        cell?.btnBookMark.addTarget(self, action: #selector(self.btnBookmarkClicked(_:)), for: .touchUpInside)
//        cell?.btnShare.addTarget(self, action: #selector(self.btnSharingClicked(_:)), for: .touchUpInside)
        
        
        
        
//        let imageUrl = (self.articalData[indexPath.row] as AnyObject).value(forKey: "article_img") as? String
//        let fullUrl = NSString(format:"%@%@", ImageGetURL,imageUrl!) as String
//        let url : NSString = fullUrl as NSString
//        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
//        let searchURL : NSURL = NSURL(string: urlStr as String)!
//        
//        
//        cell?.activityIndicatorForArticalImage.isHidden = false
//        cell?.activityIndicatorForArticalImage.startAnimating()
        
//        cell?.imageViewArtical.sd_setImage(with: searchURL as URL, completed: { (image:UIImage?, error:Error?, cacheType:SDImageCacheType!, imageURL:URL?) in
//            
//            if ((error) != nil) {
//                cell?.imageViewArtical.image = UIImage.init(named: "image_placeholder.png")
//            }
//            
//            cell?.activityIndicatorForArticalImage.isHidden = true
//            
//        })
        
        
        return cell!
            
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275.0
    }
    
    
    
   
    
    
    
    
    // TODO: - POST DATA METHODS
    func postDataOnWebserviceForGetCurrentOrder(){
        let completeURL = NSString(format:"%@%@", MainURL,getCurrentOrderURL) as String
        
        let pageNumber = "\(pageNum!)"
        
        let params:NSDictionary = [
            "lang_type":Language_Type,
            "page":pageNumber,
            "limit":PAGINATION_LIMITE
        ]
        
        let finalParams:NSDictionary = [
            "data" : params
        ]
        
        print("GetCurrentOrder API Parameter :",finalParams)
        print("GetCurrentOrder API URL :",completeURL)
        
        let sampleProtocol = SyncManager()
        sampleProtocol.delegate = self
        sampleProtocol.webServiceCall(completeURL, withParams: finalParams as! [AnyHashable : Any], withTag: getCurrentOrderURLTag)
        
    }
    
    
    
    func syncSuccess(_ responseObject: Any!, withTag tag: Int) {
        switch tag {
        case getCurrentOrderURLTag:
            let resultDict = responseObject as! NSDictionary;
            print("GetCurrentOrder Response  : \(resultDict)")
            
            if resultDict.value(forKey: "status") as! String == "1"{
                var myData = NSArray()
                
                if self.pageNum == 1{
                    self.articalData = NSMutableArray()
                    self.articalDataGlobalData = NSMutableArray()
                }
                
                myData = resultDict.value(forKey: "data") as! NSArray
                
                if (myData.count > 0) {
                    //                                self.dishGlobalData.addObjects(from: (myData) as! [Any])
                    for i in 0...myData.count - 1 {
                        self.articalDataGlobalData.add(myData[i])
                    }
                    
                    for i in 0...myData.count - 1 {
                        self.articalData.add(myData[i])
                    }
                    
                    
                    //                                self.searchStatusFilter()
                    
                    
                    if (myData.count < PAGINATION_LIMITE) {
                        if (self.pageNum > 0) {
                            self.pageNum = self.pageNum - 1
                        }
                        self.isLoading = false
                    }else{
                        self.isLoading = true
                    }
                }
                else{
                    self.isLoading = false
                    if (self.pageNum > 0) {
                        self.pageNum = self.pageNum - 1
                    }
                    
                    if self.articalData.count == 0{
                        self.tableViewCurrentOrder.isHidden = true
                    }
                    else{
                        self.tableViewCurrentOrder.isHidden = false
                    }
                }
                
                self.tableViewCurrentOrder.reloadData()
                self.removeLoadingIndicatiorOnFooterOnTableViewCurrentOrder()
                
                
            }
            else if resultDict.value(forKey: "status") as! String == "0"{
            }
            else if resultDict.value(forKey: "status") as! String == "2"{
            }
            break
            
       
            
        default:
            break
            
        }
        
    }
    func syncFailure(_ error: Error!, withTag tag: Int) {
        switch tag {
            
        case getCurrentOrderURLTag:
            self.isLoading = false
            if (self.pageNum > 0) {
                self.pageNum = self.pageNum - 1
            }
            self.removeLoadingIndicatiorOnFooterOnTableViewCurrentOrder()

            
            break
            
        default:
            break
            
        }
        print("syncFailure Error : ",error.localizedDescription)
    }
    
    func convertDateToDeviceTimeZone(myDateString:String,Strformat:String,returnFormat:String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = Strformat
        
        //Create the date assuming the given string is in GMT
        dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
        
        let date = dateFormater.date(from: myDateString)
        
        dateFormater.dateFormat = returnFormat
        //Create a date string in the local timezone
        dateFormater.timeZone = TimeZone(secondsFromGMT: NSTimeZone.local.secondsFromGMT())
        let localDateString = dateFormater.string(from: date!)
        
        return localDateString
    }
}
