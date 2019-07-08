//
//  ViewController.swift
//  HeadyProducts
//
//  Created by apple on 7/8/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblCategories: UITableView!
    var aryCategories = [Any]()
    var aryVariants = [String:Any]()
    
    var loaded = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblCategories.delegate = self
        self.tblCategories.dataSource = self
        
        self.tblCategories.register(UINib(nibName: "ProductsCell", bundle: nil), forCellReuseIdentifier: "ProductsCell")
        //fetchData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //to call api only once
        if loaded == 0
        {
            loaded = 1
            DispatchQueue.main.async {
                self.getCategoriesFromAPI()
            }
        }
        
    }
    func saveToJsonFile(json:AnyObject) {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Categories.json")
        print(fileUrl)
        
        // Create a write-only stream
        guard let stream = OutputStream(toFileAtPath: fileUrl.path, append: false) else { return }
        stream.open()
        defer {
            stream.close()
        }
        
        // Transform array into data and save it into file
        var error: NSError?
        JSONSerialization.writeJSONObject(json, to: stream, options: [], error: &error)
        
        // Handle error
        if let error = error {
            print(error)
            self.displayAlert(strMsg: "Unable to write to JSON file")
        }else{
            print("written to json")
            self.retrieveFromJsonFile()
        }
    }
    
    // MARK: API Call
    func getCategoriesFromAPI()
    {
        
        let session = URLSession.shared
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let url = URL(string: appDelegate.strBaseURL) else { return  }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")        // the expected response is also JSON
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil || data == nil {
                self.displayAlert(strMsg: error?.localizedDescription as! NSString)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                self.displayAlert(strMsg: "Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                self.displayAlert(strMsg: "Invalid MIME Type")

                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
                DispatchQueue.main.async {
                    self.saveToJsonFile(json: json as AnyObject)
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func retrieveFromJsonFile() {
        // Get the url of Persons.json in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Categories.json")
        
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])

            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>{
                // do stuff
                print(jsonResult)
                if let categories = jsonResult["categories"] as? [Any] {
                    aryCategories = categories
                    print(aryCategories.count)
                    self.title = String(describing:"Categories: (\(aryCategories.count))")
                    
                    DispatchQueue.main.async {
                        self.tblCategories.reloadData()
                    }
                }
                
            }
        } catch {
            // handle error
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
        return aryCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsCell", for: indexPath) as! ProductsCell
        
        let dicData = aryCategories[indexPath.row] as AnyObject?
        if let strTitle = dicData?.object(forKey: "name")
        {
            cell.lblTitle.text = strTitle as? String

        }

        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        //print("You selected cell #\(indexPath.row)!")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ProductsVC") as! ProductsVC
        vc.index = indexPath.row
        vc.aryCategories = aryCategories
                self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
}

