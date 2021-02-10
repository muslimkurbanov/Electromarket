//
//  SelectTestVC.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 09.02.2021.
//

import UIKit

class SelectTestVC: UIViewController {
    
    @IBOutlet weak var selectTestTableView: UITableView!
    
//    let arrayOfNames = ["Лампочки","Светильники","Стабилизаторы","Реле напряжения","Провода"]
    
    let arrayOfNames = ["Тест по стабилизаторыам","Тест по реле напряжения","Тест по проводам"]
    let arrayOfImages = [#imageLiteral(resourceName: "relay"),#imageLiteral(resourceName: "stable"), #imageLiteral(resourceName: "wires") ]
    var keys = ["stable","relay","wires"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectTestTableView.delegate = self
        selectTestTableView.dataSource = self
        

    }
}

extension SelectTestVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrayOfNames[indexPath.row]
        cell.imageView?.image = arrayOfImages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToTest(key: keys[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SelectTestVC {
    func pushToTest(key: String) {
        let sb = UIStoryboard(name: "Test", bundle: nil)
        let vc = sb.instantiateViewController(identifier: key)
        navigationController?.pushViewController(vc, animated: true)
    }
}
