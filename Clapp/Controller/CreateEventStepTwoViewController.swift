//
//  CreateEventStepTwoViewController.swift
//  Clapp
//
//  Created by mac on 08/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

protocol CreateEventStepTwoViewControllerDelegate {
    func cancel()
}

class CreateEventStepTwoViewController: UIViewController {

    @IBOutlet weak var eventDateTimePicker: UIDatePicker!
    @IBOutlet weak var eventLocationField: UITextField!
    @IBOutlet weak var eventDescriptionField: UITextField!
    
    var delegate : CreateEventStepTwoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func userDidCancel(_ sender: Any) {
        delegate?.cancel()
    }
    
}
