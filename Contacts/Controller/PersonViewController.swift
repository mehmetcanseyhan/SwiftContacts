//
//  PersonViewController.swift
//  Contacts
//
//  Created by Flyco Developer on 22.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit
import CoreData

class PersonViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var textTel: UITextField!
    @IBOutlet weak var textSurname: UITextField!
    @IBOutlet weak var textName: UITextField!
    
    var uid:String = ""
    var personInfo:NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.navBar.topItem?.title = "Person Operations"
        let aciton = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        self.imagePhoto.addGestureRecognizer(aciton)
        //print(uid)
        personLoad()
    }
    
   
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deletePerson(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Person", message: "Person will be deleted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
           self.personDelete()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func savePerson(_ sender: Any) {
        if uid.isEmpty {
            personAdd()
        } else {
            personUpdate()
        }
    }
    
    @objc func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func personAdd() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let data = NSEntityDescription.insertNewObject(forEntityName: "Persons", into: context)
        data.setValue(UUID().uuidString, forKey: "uid")
        data.setValue(textName.text!, forKey: "name")
        data.setValue(textSurname.text!, forKey: "surname")
        data.setValue(textTel.text!, forKey: "tel")
        data.setValue(imagePhoto.image?.jpegData(compressionQuality: 0.5), forKey: "image")
        
        do {
            try context.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    func personUpdate() {
        if self.personInfo != nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            personInfo?.setValue(UUID().uuidString, forKey: "uid")
            
            personInfo!.setValue(UUID().uuidString, forKey: "uid")
            personInfo!.setValue(textName.text!, forKey: "name")
            personInfo!.setValue(textSurname.text!, forKey: "surname")
            personInfo!.setValue(textTel.text!, forKey: "tel")
            personInfo!.setValue(imagePhoto.image?.jpegData(compressionQuality: 0.5), forKey: "image")
            
            do {
                try context.save()
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        
    }
    
    func personDelete() {
        
        if personInfo != nil {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            context.delete(self.personInfo!)
            try context.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func personLoad() {
        
        guard !uid.isEmpty else {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Persons")
        request.predicate = NSPredicate(format: "uid = %@", uid)
        
        do {
            let result:NSArray =  try context.fetch(request) as NSArray
            if result.count > 0 {
                for row in result as! [NSManagedObject] {
                    self.personInfo = row
                    let name = row.value(forKey: "name") as! String
                    let surname = row.value(forKey: "surname") as! String
                    let tel = row.value(forKey: "tel") as! String
                    let image = row.value(forKey: "image") as! Data
                    
                    textTel.text = tel
                    textName.text = name
                    textSurname.text = surname
                    
                    imagePhoto.image = UIImage(data: image)
                    self.navBar.topItem?.title = name + " " + surname
                }
            }
        } catch let error as NSError {
          print(error.localizedDescription)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imagePhoto.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
