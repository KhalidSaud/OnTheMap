//
//  StudentPOSTResponse.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 24/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation

struct StudentPOSTResponse: Codable {
    let createdAt, objectID: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectID = "objectId"
    }
}
