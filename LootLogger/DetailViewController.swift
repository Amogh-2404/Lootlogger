//
//  DetailViewController.swift
//  LootLogger
//
//  Created by R.AMOGH on 17/05/24.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet var nameField: UITextField!
    
    
    @IBOutlet var serialNumberField: UITextField!
    
    
    @IBOutlet var valueField: UITextField!
    
    @IBOutlet var dateLabel: UILabel!
    
    
    
    @IBOutlet var imageView: UIImageView!
    
    
    
    @IBAction func choosePhotoSource(
        _ sender: UIBarButtonItem
    ) {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.sourceItem = sender
        
        if UIImagePickerController.isSourceTypeAvailable(
            .camera
        ){
            let cameraAction = UIAlertAction(
                title: "Camera",
                style: .default
            ){ _ in
                let imagePicker = self.imagePicker(
                    for: .camera
                )
                self.present(imagePicker,animated: true,completion: nil)
                
            }
            alertController.addAction(
                cameraAction
            )
        }
        
        let photoLibraryAction = UIAlertAction(
            title: "Photo Library",
            style: .default
        ){_ in
            let imagePicker = self.imagePicker(
                for: .photoLibrary
            )
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.sourceItem = sender
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(
            photoLibraryAction
        )
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        alertController.addAction(
            cancelAction
        )
        
        
        present(
            alertController,
            animated: true,
            completion: nil
        )
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueField.keyboardType = .numberPad
        
    }
    
    var item:Item!{
        didSet{
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    override func viewWillAppear(
        _ animated: Bool
    ) {
        super.viewWillAppear(
            animated
        )
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        
        valueField.text = numberFormatter.string(
            from: NSNumber(
                value: item.valueInDollars
            )
        )
        dateLabel.text = dateFormatter.string(
            from: item.dateCreated
        )
        
        // Get the item key
        let key = item.itemKey
        
        // If there is an associated image with the item, display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
        
    }
    
    
    override func viewWillDisappear(
        _ animated: Bool
    ) {
        super.viewWillDisappear(
            animated
        )
        
        // Clear first responder
        view.endEditing(
            true
        )
        
        
        // "Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
           let value = numberFormatter.number(
            from: valueText
           )
        {
            item.valueInDollars = value.intValue
        }else{
            item.valueInDollars = 0
        }
    }
    
    
    
    // Hitting return key to get rid of the keyboard
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func backgroundTapped(
        _ sender: UITapGestureRecognizer
    ) {
        
        view.endEditing(
            true
        )
    }
    
    
    // Image Picker
    func imagePicker(
        for sourceType: UIImagePickerController.SourceType
    )->UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    
    // Saving the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get picked image from image dictionary
        let image = info[.originalImage] as! UIImage
        
        // Put that image on the screen in the image view
        imageView.image = image
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Take image picker off the screen - we must call this dismiss method
        dismiss(animated: true,completion: nil)
    }
    
    
}
