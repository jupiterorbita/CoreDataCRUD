//
//  ViewController.swift
//  CRUD
//
//  Created by Developer on 7/11/18.
//  Copyright © 2018 Dane Olsen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    var tableData: [User] = []
    var userEditing: Bool = false
    var editUserObject: [User] = []
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var hobby: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchUsers()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if userEditing == false{
            createUser()
        }else{
            updateUser()
        }
    }
    
    
    func createUser(){
        let newUser = User(context: context)
        newUser.first_name = firstName.text
        newUser.last_name = lastName.text
        newUser.age = (Int16(age.text!))!
        newUser.hobby = hobby.text
        saveContext()
        fetchUsers()
//
//        print(newUser.first_name!, newUser.hobby!)

    }
    
    func fetchUsers(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        do {
            let fetchedUsers = try context.fetch(userRequest)
            tableData = fetchedUsers
            tableView.reloadData()
            // Here we can store the fetched data in an array
        } catch {
            print(error)
        }
    }
    
    
    func updateUser(){
        
        editUserObject[0].first_name = firstName.text
        editUserObject[0].last_name = lastName.text
        if let age = Int16(age.text!){
            editUserObject[0].age = (Int16(age))
        }else{
            editUserObject[0].age = 0
        }
        editUserObject[0].hobby = hobby.text
        saveContext()
        fetchUsers()
        userEditing = false
        editUserObject = []
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit"){action, view, completionHandler in
            print(indexPath.row, self.tableData[indexPath.row])
            self.editUserObject = [self.tableData[indexPath.row]]
            self.firstName.text = self.tableData[indexPath.row].first_name
            self.lastName.text = self.tableData[indexPath.row].last_name
            self.age.text = "\(self.tableData[indexPath.row].age)"
            self.hobby.text = self.tableData[indexPath.row].hobby
            self.userEditing = true
            completionHandler(false)
            
        }
        editAction.backgroundColor = UIColor.green
        let swipeConfig = UISwipeActionsConfiguration(actions: [editAction])
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){action,view,completionHandler in
//            print(indexPath.row, self.tableData[indexPath.row])
            self.context.delete(self.tableData[indexPath.row])
            self.tableData.remove(at: indexPath.row)
            self.saveContext()
            tableView.reloadData()
        }
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    
    

}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row].first_name
        cell.detailTextLabel?.text = tableData[indexPath.row].hobby
        return cell
    }
    
    
}


