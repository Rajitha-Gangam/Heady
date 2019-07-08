//
//  ProductsVC.swift
//  HeadyProducts
//
//  Created by apple on 7/8/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class VariantsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var aryProducts = [Any]()
    var aryVariants = [Any]()
    var index = -1
    @IBOutlet weak var tblVariants: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tblVariants.delegate = self
        self.tblVariants.dataSource = self
        
        self.tblVariants.register(UINib(nibName: "VariantsCell", bundle: nil), forCellReuseIdentifier: "VariantsCell")
        fetchData()
        
    }
    func fetchData()
    {
        
        if let variants = aryProducts[index] as? AnyObject
        {
            if let  aryVariants1 = variants.object(forKey:"variants") as? [Any]
            {
                aryVariants = aryVariants1
                print(aryVariants.count)
                self.title = String(describing:"Variants:  (\(aryVariants.count))")

                
                DispatchQueue.main.async {
                    self.tblVariants.reloadData()
                }
            }
        }
        
        
        
        
    }
    func displayAlert(strMsg:NSString)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: strMsg as String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }
            ))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryVariants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VariantsCell", for: indexPath) as! VariantsCell
        
        let dicData = aryVariants[indexPath.row] as AnyObject?
        if let strColor = dicData?.object(forKey: "color")
        {
            cell.lblColor.text = strColor as? String
        }
        if let strSize = dicData?.object(forKey: "size")
        {
            if let size = strSize as? Int
            {
                cell.lblSize.text = String(describing:size)
            }
        }
        if let strPrice = dicData?.object(forKey: "price")
        {
            if let price = strPrice as? Int
            {
                cell.lblPrice.text = String(describing:price)
            }
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        //print("You selected cell #\(indexPath.row)!")
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "FeedDetails") as! FeedDetails
        //        let dicData = self.dataProducts[indexPath.row] as AnyObject?
        //
        //        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
