//
//  ViewController.swift
//  Park_Stamp_Generator
//
//  Created by Rishabh Ganesh on 6/1/22.
//

import UIKit

class DataViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var parkInput: UITextField!
    @IBOutlet weak var dateInput: UITextField!
    @IBOutlet weak var attractionInput: UITextField!
    
    @IBOutlet weak var generateStampButton: UIButton!
    @IBOutlet weak var parkLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var attractionLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        parkInput.delegate = self
        dateInput.delegate = self
        attractionInput.delegate = self
        generateStampButton.isEnabled = false
        //parkLabel.text = "Park name: \(parkInput.text!)"
        //dateLabel.text = "Date: \(dateInput.text!)"
        //attractionLabel.text = "Loc. / Attr. name: \(attractionInput.text!)"

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        parkInput.resignFirstResponder()
        dateInput.resignFirstResponder()
        attractionInput.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "switcher"
        {
               let destVC = segue.destination as! StampViewController
               destVC.parkString = parkInput.text!
               destVC.dateString = dateInput.text!
               destVC.attractionString = attractionInput.text!
        }
    }
    @IBAction func generateStampTapped(_ sender: Any)
    {
        performSegue(withIdentifier: "switcher", sender: AnyObject.self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        parkLabel.text = "Park name: \(parkInput.text!)"
        dateLabel.text = "Date: \(dateInput.text!)"
        attractionLabel.text = "Loc. / Attr. name: \(attractionInput.text!)"
        if parkInput.text != "" && dateInput.text != "" && attractionInput.text != ""
        {
            generateStampButton.isEnabled = true
        }
        return true
    }
    
}

/*extension UIViewController: UITextFieldDelegate
{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}*/

