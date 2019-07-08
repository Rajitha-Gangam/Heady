//
//  ProductsVC.swift
//  HeadyProducts
//
//  Created by apple on 7/8/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class ProductsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var aryProducts = [Any]()
    var aryCategories = [Any]()
    var index = -1
    @IBOutlet weak var tblProducts: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblProducts.delegate = self
        self.tblProducts.dataSource = self
        
        self.tblProducts.register(UINib(nibName: "ProductsCell", bundle: nil), forCellReuseIdentifier: "ProductsCell")
        fetchData()
        
    }
    func fetchData()
    {

        if let products = aryCategories[index] as? AnyObject
        {
            if let  aryProducts1 = products.object(forKey:"products") as? [Any]
          {
            aryProducts = aryProducts1
            print(aryProducts.count)
            self.title = String(describing:"Products:  (\(aryProducts.count))")
            DispatchQueue.main.async {
                self.tblProducts.reloadData()
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
        return aryProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsCell", for: indexPath) as! ProductsCell
        
        let dicData = aryProducts[indexPath.row] as AnyObject?
        if let strTitle = dicData?.object(forKey: "name")
        {
            cell.lblTitle.text = strTitle as? String
            
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        //print("You selected cell #\(indexPath.row)!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VariantsVC") as! VariantsVC
        vc.index = indexPath.row
        vc.aryProducts = aryProducts
        self.navigationController?.pushViewController(vc, animated: true)
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
