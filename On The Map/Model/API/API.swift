//
//  StudentsGET.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 23/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation
import MapKit

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
            
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                
                print("no status code")
                completion(nil, error)
                return
            }
            
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                
                guard let data = data else {
                    print("no data")
                    completion(nil, error)
                    return
                }
                
                do {
                    let newData = data.dropFirst(5)
                    let responseObject = try JSONDecoder().decode(UdacityPOSTSessionResponse.self, from: newData)
                    print("session result is here")
                    completion(responseObject, nil)
                } catch {
                    print("no result")
                    print(error)
                    completion(nil, error)
                    return
                }
                
            } else {
                switch httpStatusCode {
                    case 400:print("Bad Request")
                    case 401:print("Invalid Credentials")
                    case 402:print("Unauthorized")
                    case 405:print("HttpMethod Not Allowed")
                    case 410:print("URL Changed")
                    case 500:print("Server Error")
                    default: print("Something is wrong.")
                }
                completion(nil, error)
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
                //                print(String(data: data, encoding: .utf8)!)
                let newData = data.dropFirst(5)
                let responseObject = try JSONDecoder().decode(UdacityGETResponse.self, from: newData)
                print("user result is here")
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
                //                print(String(data: data, encoding: .utf8)!)
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
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print("no data")
                completion(nil, error)
                return
            }
            
            do {
                
                let responseObject = try JSONDecoder().decode(StudentGETResponse.self, from: data)
                print("students result is here")
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
    
    class func PostNewLocation(userId: String, firstName: String, lastName: String, city: String, mediaURL: String, location: CLLocationCoordinate2D, completion: @escaping (StudentPOSTResponse?, Error?) -> Void ) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userId)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(city)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(error!.localizedDescription)
                completion(nil, error)
                return
            }
            
            do {
                
                let responseObject = try JSONDecoder().decode(StudentPOSTResponse.self, from: data)
                print("post result is here")
                print(userId)
                print(String(data: data, encoding: .utf8)!)
                completion(responseObject, nil)
            } catch {
                print("no result")
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
        }
        task.resume()
    }
    
    class func PutYourLocation(userId: String, firstName: String, lastName: String, city: String, mediaURL: String, location: CLLocationCoordinate2D, completion: @escaping (StudentPUTResponse?, Error?) -> Void ) {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/\(UserData.postId)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userId)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(city)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("no data")
                print(error!.localizedDescription)
                completion(nil, error)
                return
            }
            
            do {
                print("put result is here")
                print(String(data: data, encoding: .utf8)!)
                let responseObject = try JSONDecoder().decode(StudentPUTResponse.self, from: data)
                completion(responseObject, nil)
            } catch {
                print("no result")
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
        }
        task.resume()
    }
    
}
