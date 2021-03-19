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
    
    var user: UserProfile!
    var ref: DatabaseReference!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = UserProfile(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        // Do any additional setup after loading the view.
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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath)
        return cell
    }
    
    
}
