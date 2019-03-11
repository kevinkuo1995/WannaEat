//
//  TableViewController.swift
//  WannaEat
//
//  Created by KUO Chin Wei on 2018/10/23.
//  Copyright © 2018 KevinKuo. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol TBVDelegate {
    func sentBackArary(lastArray:Array<String>)
}

class TableViewController: UITableViewController,UITextFieldDelegate,GADBannerViewDelegate {
    
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-3528742443104185/7975676336"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adBannerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return adBannerView.frame.height
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        //tableView.tableFooterView?.frame = bannerView.frame
        //tableView.tableFooterView = bannerView
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        UIView.animate(withDuration: 0.5){
            bannerView.transform = CGAffineTransform.identity
        }
        
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{return .lightContent
        }
    }
    
    var infoFromViewOne:Array<String>?
    var delegate:TBVDelegate?
    
    @IBOutlet var yaTable: UITableView!
    var list = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        yaTable.delegate = self
        yaTable.dataSource = self
        let backgroundImage = UIImage(named: "12334")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        adBannerView.load(GADRequest())
    }
    override func viewWillAppear(_ animated: Bool) {
        list = infoFromViewOne!
    }
    
    @IBAction func backToViewOne(_ sender: UIBarButtonItem) {
        delegate?.sentBackArary(lastArray: list)
        UserDefaults.standard.set(list, forKey: "lists")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "新增類別",
            message: "請輸入想吃的食物類別",
            preferredStyle: .alert)
        
        // 建立輸入框
        alertController.addTextField(configurationHandler: {(textfield:UITextField!) -> Void in
            textfield.becomeFirstResponder()
        })
        let firstTextField = alertController.textFields![0] as UITextField
        firstTextField.delegate = self
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[新增]按鈕
        let okAction = UIAlertAction(
            title: "新增",
            style: .default) {
                (action: UIAlertAction!) -> Void in
                let acc =
                    (alertController.textFields?.first)!
                        as UITextField
                if acc.text != ""{
                    self.list.append(acc.text!)
                    print(self.list)
                    self.yaTable.reloadData()
                    UserDefaults.standard.set(self.list, forKey: "lists")
                }
                
                
        }
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont(name: "arial", size: 24)
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(list, forKey: "lists")
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addButton(UIBarButtonItem())
        return true
    }
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "修改類別",
            message: "請輸入想吃的食物類別",
            preferredStyle: .alert)
        
        // 建立輸入框
        alertController.addTextField(configurationHandler: {(textfield:UITextField!) -> Void in
            textfield.becomeFirstResponder()
        })
        let firstTextField = alertController.textFields![0] as UITextField
        firstTextField.delegate = self
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[新增]按鈕
        let okAction = UIAlertAction(
            title: "修改",
            style: .default) {
                (action: UIAlertAction!) -> Void in
                let acc =
                    (alertController.textFields?.first)!
                        as UITextField
                if acc.text != ""{
                    self.list[indexPath.row] = acc.text!
                    print(self.list)
                    self.yaTable.reloadData()
                    UserDefaults.standard.set(self.list, forKey: "lists")
                }else{
                    self.list.remove(at: indexPath.row)
                    print(self.list)
                    self.yaTable.reloadData()
                    UserDefaults.standard.set(self.list, forKey: "lists")
                }
                
                
        }
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
