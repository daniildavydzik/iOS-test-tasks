//
//  AddRestaurantControllerTableViewController.swift
//  FoodApp
//
//  Created by Daniil Davydik  on 19.04.17.
//  Copyright © 2017 DavydzikInc. All rights reserved.
//
import CoreData
import UIKit

class AddRestaurantControllerTableViewController: UITableViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    var isVisited = true
    var imageData : Data?
    @IBOutlet var imageVIew : UIImageView!
    @IBOutlet var nameTextField : UITextField!
     @IBOutlet var typeTextField : UITextField!
     @IBOutlet var locationTextField : UITextField!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var phoneTextField : UITextField!
    var restaurant: RestaurantMO!
    @IBAction func saveData(sender: AnyObject){
        if self.nameTextField.text == "" || self.typeTextField.text == "" || self.locationTextField.text == "" || self.phoneTextField.text == "" {
            let alertView = UIAlertController(title: "Please enter all fields", message: "Some fields are not write", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertView, animated: true, completion: nil)
            
        }else{
            if  let image = imageVIew.image {
                if let imageData = UIImagePNGRepresentation(image) {
                    self.imageData = imageData
                }
                
            }
           
           
                 restaurant = RestaurantMO(context: DataStore.defaultLocalDB.persistentContainer.viewContext )
                 restaurant.name = nameTextField.text
                restaurant.location = locationTextField.text
                restaurant.type = typeTextField.text
                restaurant.isVisited = isVisited
                restaurant.phone = phoneTextField.text
                if  let image = imageVIew.image {
                    if let imageData = UIImagePNGRepresentation(image) {
                        restaurant.image = NSData(data: imageData)
                    }
                    
                }
                print("Save Data To Context ")
                DataStore.defaultLocalDB.saveContext()
            
            
        
        dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func changeBtnColor(sender:UIButton){
        if sender == yesButton {
            isVisited = true
            yesButton.backgroundColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            
            // Change the backgroundColor property of noButton to gray
            noButton.backgroundColor = UIColor(red: 218.0/255.0, green: 223.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        }else{
        isVisited = false
            noButton.backgroundColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            
            // Change the backgroundColor property of noButton to gray
            yesButton.backgroundColor = UIColor(red: 218.0/255.0, green: 223.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true, completion: nil)
                
            }
        }else{
        tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    // MARK: - Table view data source
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imageVIew.image = image
            self.imageVIew.clipsToBounds = true
            self.imageVIew.contentMode = .scaleAspectFill
        }
        let leadingConstraint = NSLayoutConstraint(item : self.imageVIew, attribute : NSLayoutAttribute.leading, relatedBy : NSLayoutRelation.equal, toItem : imageVIew.superview, attribute : NSLayoutAttribute.leading, multiplier: 1, constant : 0)
        leadingConstraint.isActive = true
         let trailingConstraint = NSLayoutConstraint(item : self.imageVIew, attribute : NSLayoutAttribute.trailing, relatedBy : NSLayoutRelation.equal, toItem : imageVIew.superview, attribute : NSLayoutAttribute.trailing, multiplier: 1, constant : 0)
         trailingConstraint.isActive = true
         let topConstraint = NSLayoutConstraint(item : self.imageVIew, attribute : NSLayoutAttribute.top, relatedBy : NSLayoutRelation.equal, toItem : imageVIew.superview, attribute : NSLayoutAttribute.top, multiplier: 1, constant : 0)
         topConstraint.isActive = true
         let bottomConstraint = NSLayoutConstraint(item : self.imageVIew, attribute : NSLayoutAttribute.bottom, relatedBy : NSLayoutRelation.equal, toItem : imageVIew.superview, attribute : NSLayoutAttribute.bottom, multiplier: 1, constant : 0)
         bottomConstraint.isActive = true
        dismiss(animated: true, completion: nil)
    }
   
}
