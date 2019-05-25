//
//  TableViewController.swift
//  On The Map
//
//  Created by KHALID ALSUBAIE on 23/05/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    var students: [Dummy] = []
    var students: [Student] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

//        students = GetDummyData()
        
//        getStudents()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getStudents()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if UserData.hasPost {
            showAlertChoice(title: "Notice", message: "Do you want to overwrite your previous location ?")
        } else {
            toFind()
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        getStudents()
    }
    
    func getStudents() {
        let indicator = startAnActivityIndicator()
        indicator.startAnimating()
        API.GetAllStudentsFromAPI { (data, error) in
            
            if let data = data {
                self.students = data.studentsResult
                self.checkIfHasPost(students: self.students)
                DispatchQueue.main.async {
                    indicator.stopAnimating()
                    self.tableView.reloadData()
                }
                print("list has students")
            }
            if error != nil {
                DispatchQueue.main.async {
                    indicator.stopAnimating()
                }
                print("list has no students")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "\(students[indexPath.row].firstName) \(students[indexPath.row].lastName) : \(students[indexPath.row].mediaURL)"
        cell.imageView?.image = UIImage(named: "pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: students[indexPath.row].mediaURL) {
            UIApplication.shared.open(url , options: [:]) { (bool) in
            }
        }
    }
    
    @IBAction func logtouTapped(_ sender: Any) {
        logOut()
    }
}
