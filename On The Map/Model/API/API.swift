//
//  StudentsGET.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 23/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation

class API{
    
    class func GetSession(email: String, password: String, completion: @escaping (UdacityPOSTSessionResponse?, Error?) -> Void ) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            
            
            if error != nil { // Handle error…
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("no data")
                completion(nil, error)
                return
            }
            
           
            
            do {
                let newData = data.dropFirst(5)
                let responseObject = try JSONDecoder().decode(UdacityPOSTSessionResponse.self, from: newData)
                print("result is here")
                completion(responseObject, nil)
            } catch {
                print("no result")
                print(error)
                completion(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    class func getUserData(userKey: String, completion: @escaping (UdacityGETResponse?, Error?) -> Void ) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(userKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil { // Handle error…
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("no data")
                completion(nil, error)
                return
            }
            
            do {
                print(String(data: data, encoding: .utf8)!)
                let newData = data.dropFirst(5)
                let responseObject = try JSONDecoder().decode(UdacityGETResponse.self, from: newData)
                print("result is here")
                completion(responseObject, nil)
            } catch {
                print("no result")
                print(error)
                completion(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    class func DeleteSession(completion: @escaping (UdacityDELETESessionResponse?, Error?) -> Void ) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil { // Handle error…
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("no data")
                completion(nil, error)
                return
            }
            
            do {
                print(String(data: data, encoding: .utf8)!)
                let newData = data.dropFirst(5)
                let responseObject = try JSONDecoder().decode(UdacityDELETESessionResponse.self, from: newData)
                print("session deleted")
                completion(responseObject, nil)
            } catch {
                print("no result")
                print(error)
                completion(nil, error)
                return
            }
            
        }
        task.resume()
    }
    
    class func GetAllStudentsFromAPI(completion: @escaping (StudentGETResponse?, Error?) -> Void ) {
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("no data")
                completion(nil, error)
                return
            }
            
            do {
                
                let responseObject = try JSONDecoder().decode(StudentGETResponse.self, from: data)
                print("result is here")
                completion(responseObject, nil)
            } catch {
                print("no result")
                print(error)
                completion(nil, error)
                return
            }
            
//            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
}
