//
//  ViewController.swift
//  WannaEat
//
//  Created by KUO Chin Wei on 2018/10/23.
//  Copyright © 2018 KevinKuo. All rights reserved.
//

import UIKit
import GoogleMobileAds


class ViewController: UIViewController,TBVDelegate,GADBannerViewDelegate,GADInterstitialDelegate {


    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var buttonView: UIButton!
    
    var interstitial: GADInterstitial?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{return .lightContent
        }
    }
    
    
    
    func sentBackArary(lastArray: Array<String>) {
        foodArray = lastArray
    }
    
    var foodArray = ["咖哩飯","義大利麵","牛肉麵","牛排","雞排"]
    
    
    
    
    
    

    
    
    @IBAction func choose(_ sender: UIButton) {
        
        if foodArray != []{
        let randomIndex = Int(arc4random_uniform(UInt32(foodArray.count)))
        let alertController = UIAlertController(
            title: "\n\n\n\n\n\n",
            message: "今天吃\(foodArray[randomIndex])",
            preferredStyle: .alert)
        
        let imageView = UIImageView(frame: CGRect(x: 65, y: 10, width: 135, height: 135))
            imageView.image = UIImage(named: "2493")
            alertController.view.addSubview(imageView)

        
            
        //建立[馬上去]按鈕
        let cancelAction = UIAlertAction(title: "馬上去", style: .cancel, handler: {(UIAlertAction) -> Void in
            if let keyWord = self.foodArray[randomIndex].addingPercentEncoding(withAllowedCharacters: CharacterSet.capitalizedLetters){
                let urlString = "https://www.google.com.tw/maps/search/\(keyWord)/"
                if let url = URL(string: urlString){
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }
            
        })
            // 建立[確認]按鈕
            let okAction = UIAlertAction(
                title: "確認",
                style: .default,
                handler: {(UIAlertAction) -> Void in
                    let randomAD = Int(arc4random_uniform(UInt32(self.foodArray.count)))
                    print(randomAD)
                    print(randomIndex)
                    if randomAD == randomIndex{
                        print(randomAD)
                        print(randomIndex)
                        self.interstitial?.present(fromRootViewController: self)
                    }
                    
                   
                    
                        })

            
             alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
  
            alertController.view.tintColor = UIColor.orange
       
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
        print(foodArray)
        }else{
            let alertController = UIAlertController(
                title: "提示",
                message: "請輸入類別",
                preferredStyle: .alert)
            
            // 建立[確認]按鈕
            let okAction = UIAlertAction(
                title: "確認",
                style: .default,
                handler: nil)
            alertController.addAction(okAction)
            // 顯示提示框
            self.present(
                alertController,
                animated: true,
                completion: nil)
        }
    }


    func createInterstital() -> GADInterstitial? {
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-3528742443104185/2046855947")
        guard let interstitial = interstitial else {
            return nil
        }

        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitial.load(request)
        interstitial.delegate = self
        return interstitial
    }
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let request = GADRequest()
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-3528742443104185/7975676336"
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(request)
        
        interstitial = createInterstital()
        
        if let loadedlists = UserDefaults.standard.stringArray(forKey: "lists"){
            foodArray = loadedlists
        }
        
    }

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitial loaded succcessfully")
    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to recieve interstitial")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createInterstital()
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded succesfully")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func goToNext(_ sender: UIButton) {
        performSegue(withIdentifier: "gotonext", sender: foodArray)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotonext"{
            if let table = segue.destination as? TableViewController{
                table.infoFromViewOne = sender as? Array
                table.delegate = self
            }
        }
    }
    
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
