//
//  UdacityPOSTSessionResponse.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 24/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation

// MARK: - UdacityPOSTSessionResponse
struct UdacityPOSTSessionResponse: Codable {
    let account: Account
    let session: Session
}

// MARK: - Account
struct Account: Codable {
    let registered: Bool
    let key: String
}

// MARK: - Session
struct Session: Codable {
    let id, expiration: String
}
