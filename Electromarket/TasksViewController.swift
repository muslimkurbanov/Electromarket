//
//  TasksViewController.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 18.03.2021.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    private var user: UserProfile!
    private var ref: DatabaseReference!
    private var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = UserProfile(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ref.observe(.value) { [weak self] (snapshot) in
         
            var _tasks = [Task]()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tasksTableView.reloadData()
        }
    }
    
    @IBAction func addTaskAction(_ sender: Any) {
        let alertController = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _  in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary())
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath)
        let taskTitle = tasks[indexPath.row].title
        cell.textLabel?.text = taskTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
