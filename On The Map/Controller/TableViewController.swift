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
        
        getStudents()
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        toFind()
    }
    
    func getStudents() {
//        let ai = startAnActivityIndicator()
        API.GetAllStudentsFromAPI { (data, error) in
            
            if let data = data {
                self.students = data.studentsResult
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("list has students")
            }
            if let error = error {
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
        dismiss(animated: true, completion: nil)
    }
}
