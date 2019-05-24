//
//  DummyData.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 23/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation

struct Dummy {
    let name: String
    let url: URL
    let lat: Double
    let lon: Double
}

func GetDummyData() -> [Dummy] {
    
    var dummyArray: [Dummy] = []
    let data1 = Dummy(name: "Khalid", url: URL(string: "https://www.youtube.com/watch?v=Epb_ZZBFZIs")! , lat: 120.0, lon: 120.0)
    let data2 = Dummy(name: "Ahmed", url: URL(string: "https://www.google.com")! , lat: 120.1, lon: 120.1)
    dummyArray.append(data1)
    dummyArray.append(data2)
    return dummyArray
}
