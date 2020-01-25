//
//  ViewController.swift
//  FinalAssignmentC0761022
//
//  Created by sanjeev gupta on 2020-01-24.
//  Copyright © 2020 sanjeev gupta. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {

    var products: [Product]?
      
        @IBOutlet var textFields: [UITextField]!
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
    //        loadData()
            loadCoreData()
            
    //        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)
        }
        
        func getFilePath() -> String {
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            if documentPath.count > 0 {
                let documentDirectory = documentPath[0]
                let filePath = documentDirectory.appending("/product.txt")
                return filePath
            }
            return ""
        }
        
        func loadData() {
            let filePath = getFilePath()
            products = [Product]()
            if FileManager.default.fileExists(atPath: filePath) {
                do {
                    // extract data
                    let fileContents = try String(contentsOfFile: filePath)
                    let contentArray = fileContents.components(separatedBy: "\n")
                    for content in contentArray {
                        let productcontent = content.components(separatedBy: ",")
                        if productcontent.count == 4 {
                            let product = Product(productid: productcontent[0], productname: productcontent[1], productdescription: productcontent[2], productprice: String(productcontent[3]))
                            products?.append(product)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }

        @IBAction func addBook(_ sender: UIBarButtonItem) {
            let productid = textFields[0].text ?? ""
            let productname = textFields[1].text ?? ""
            let productdescription = textFields[2].text ?? ""
            let productprice = textFields[3].text ?? ""
            
            let product = Product(productid: productid, productname: productname, productdescription: productdescription, productprice: productprice)
            products?.append(product)
            
            for textField in textFields {
                textField.text = ""
                textField.resignFirstResponder()
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let producttable = segue.destination as? ProductTable {
                producttable.products = self.products
            }
        }
        
        @objc func saveData() {
            let filePath = getFilePath()
            var saveString = ""
            for product in products! {
                saveString = "\(saveString)\(product.productid),\(product.productname),\(product.productdescription),\(product.productprice)\n"
            }
            // write to path
            do {
                try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
            } catch {
                print(error)
            }
        }
        
        @objc func saveCoreData() {
            // call clear core data
            clearCoreData()
            // create an instance of app delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            // second step is context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            for book in products! {
                let productentity = NSEntityDescription.insertNewObject(forEntityName: "ProductsModel", into: managedContext)
                productentity.setValue(book.productid, forKey: "productid")
                productentity.setValue(book.productname, forKey: "productname")
                productentity.setValue(book.productdescription, forKey: "productdescription")
                productentity.setValue(book.productprice, forKey: "productprice")
                
                // save context
                do {
                    try managedContext.save()
                } catch {
                    print(error)
                }
            }
        }
        
        func loadCoreData() {
            products = [Product]()
            // create an instance of app delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            // second step is context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductsModel")
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                if results is [NSManagedObject] {
                    for result in results as! [NSManagedObject] {
                        let productdescription = result.value(forKey: "productdescription") as! String
                        let productid = result.value(forKey: "productid") as! String
                        let productname = result.value(forKey: "productname") as! String
                        let productprice = result.value(forKey: "productprice") as! String
                        
                        products?.append(Product(productid: productid, productname: productname, productdescription: productdescription, productprice: productprice))
                    }
                }
            } catch {
                print(error)
            }
            
        }
        
        func clearCoreData() {
            // create an instance of app delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            // second step is context
            let managedContext = appDelegate.persistentContainer.viewContext
            // create a fetch request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductsModel")
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                for managedObjects in results {
                    if let managedObjectData = managedObjects as? NSManagedObject {
                        managedContext.delete(managedObjectData)
                    }
                }
            } catch {
                print(error)
            }
            
        }


}

