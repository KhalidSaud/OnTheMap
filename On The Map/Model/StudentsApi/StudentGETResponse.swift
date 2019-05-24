//
//  StudentResult.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 23/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation

struct StudentGETResponse: Codable {
    let studentsResult: [Student]
    
    enum CodingKeys: String, CodingKey {
        case studentsResult = "results"
    }
}

struct Student: Codable {
    let createdAt, firstName, lastName: String
    let latitude, longitude: Double
    let mapString: String
    let mediaURL: String
    let objectID, uniqueKey, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt, firstName, lastName, latitude, longitude, mapString, mediaURL
        case objectID = "objectId"
        case uniqueKey, updatedAt
    }
}
