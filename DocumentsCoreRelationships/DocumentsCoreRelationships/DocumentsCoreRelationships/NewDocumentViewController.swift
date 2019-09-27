//
//  NewDocumentViewController.swift
//  DocumentsCoreRelationships
//
//  Created by Alex Davis on 9/24/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//

import UIKit

class NewDocumentViewController: UIViewController {
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var InputTextField: UITextView!
    
    var document: Document?
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = " "
        
        if let document = document {
            let name = document.name
            NameTextField.text = name
            InputTextField.text = document.content
            title = name
        }
       
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func Save(_ sender: Any) {
        guard let name = NameTextField.text else {
            alertNotifyUser(message: "Save Failed.")
            return
    }
        let documentName = name.trimmingCharacters(in: .whitespaces)
        
        let content = InputTextField.text
        
        if document == nil {
            if let category = category {
                document = Document(name: documentName, content: content, category: category)
            }
        } else {
            if let category = category {
                document?.update(name: documentName, content: content, category: category)
            }
        }
        
        if let document = document {
            do {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "Save failed.")
            }
        } else {
            alertNotifyUser(message: "Creation failed.")
        }
        
        navigationController?.popViewController(animated: true)
    }

    @IBAction func ChangeName(_ sender: Any) {
        title = NameTextField.text
    }
}
