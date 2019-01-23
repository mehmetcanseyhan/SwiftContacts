//
//  ViewController.swift
//  Contacts
//
//  Created by Flyco Developer on 22.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var list = [ListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navBar.topItem?.title = "Persons"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       tableLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = list[indexPath.row].name
        cell?.detailTextLabel?.text = list[indexPath.row].tel
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "personViewController") as! PersonViewController
        vc.uid = list[indexPath.row].uid!
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func tableLoad() {
        list.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Persons")
        request.returnsObjectsAsFaults = false
        
        do {
            let result:NSArray  = try context.fetch(request) as NSArray
            if result.count > 0 {
                for row in result as! [NSManagedObject] {
                    let uid = row.value(forKey: "uid") as! String
                    let name = row.value(forKey: "name") as! String
                    let surname = row.value(forKey: "surname") as! String
                    let tel = row.value(forKey: "tel") as! String
                    
                    list.append(ListItem(uid: uid, name: name + " " + surname, tel: tel))
                  //  print(name)
                }
            }
            self.tableView.reloadData()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }

    class ListItem {
        var uid:String?
        var name:String?
        var tel:String?
        
        init(uid:String, name:String, tel:String) {
            self.uid = uid
            self.name = name
            self.tel = tel
        }
    }
    
}

