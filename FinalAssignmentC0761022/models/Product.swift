//
//  Product.swift
//  FinalAssignmentC0761022
//
//  Created by sanjeev gupta on 2020-01-24.
//  Copyright © 2020 sanjeev gupta. All rights reserved.
//

import UIKit

class Product{
    
    internal init(productid: String, productname: String, productdescription: String, productprice: String) {
           self.productid = productid
           self.productname = productname
           self.productdescription = productdescription
           self.productprice = productprice
       }
       
       var productid: String
       var productname: String
       var productdescription: String
       var productprice: String
}
