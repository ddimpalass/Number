//
//  ColorViewController.swift
//  Number
//
//  Created by Apple on 18.12.2020.
//

import UIKit

protocol ColorViewControllerDelegate: AnyObject {
    func getNewColor(_ colorBg: Color, _ colorText: Color)
}

class ColorViewController: UIViewController{
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var viewRGB: UIView!
    @IBOutlet weak var textLabelRGB: UILabel!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var changeColorButton: UIButton!
    
    // MARK: - Private properties
    private var selectedSegmentIndex = 0
    private var colorPicker: Color = Color(red: 255,
                                           green: 255,
                                           blue: 255)
    var colorBg: Color = Color(red: 255,
                               green: 255,
                               blue: 255)
    var colorText: Color = Color(red: 85,
                                 green: 85,
                                 blue: 85)
    
    // MARK: - Properties
    weak var delegate: ColorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        getStartsColor(selectedSegmentIndex)
    }
    
    // MARK: - IB Actions
    @IBAction func chosenBgOrText(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        getStartsColor(selectedSegmentIndex)
    }
    
    @IBAction func changeColorTextField(_ sender: UITextField) {
        
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        delegate?.getNewColor(colorBg, colorText)
        dismiss(animated: true)
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        
        redTextField.text = String(Int(redSlider.value))
        greenTextField.text = String(Int(greenSlider.value))
        blueTextField.text = String(Int(blueSlider.value))
        
        colorPicker = Color(red: Int(redSlider.value),
                            green: Int(greenSlider.value),
                            blue: Int(blueSlider.value))
        
        switch selectedSegmentIndex {
        case 0:
            colorBg = colorPicker
            viewRGB.backgroundColor = UIColor(red: CGFloat(colorBg.red)/255,
                                              green: CGFloat(colorBg.green)/255,
                                              blue: CGFloat(colorBg.blue)/255,
                                              alpha: 1/1)
        case 1:
            colorText = colorPicker
            textLabelRGB.textColor = UIColor(red: CGFloat(colorText.red)/255,
                                             green: CGFloat(colorText.green)/255,
                                             blue: CGFloat(colorText.blue)/255,
                                             alpha: 1/1)
        default:
            return
        }
    }
}


// MARK: - startsColor

extension ColorViewController {
    private func getStartsColor(_ selectedSegmentIndex: Int){
        
        switch selectedSegmentIndex {
        case 0:
            redSlider.value = Float(colorBg.red)
            greenSlider.value = Float(colorBg.green)
            blueSlider.value = Float(colorBg.blue)
        case 1:
            redSlider.value = Float(colorText.red)
            greenSlider.value = Float(colorText.green)
            blueSlider.value = Float(colorText.blue)
        default:
            return
        }
        
        updateView()
        
        redTextField.text = String(Int(redSlider.value))
        greenTextField.text = String(Int(greenSlider.value))
        blueTextField.text = String(Int(blueSlider.value))
        
    }
}

// MARK: Update view color
extension ColorViewController {
    func updateView(){
        viewRGB.backgroundColor = UIColor(red: CGFloat(colorBg.red)/255,
                                          green: CGFloat(colorBg.green)/255,
                                          blue: CGFloat(colorBg.blue)/255,
                                          alpha: 1/1)
        
        textLabelRGB.textColor = UIColor(red: CGFloat(colorText.red)/255,
                                         green: CGFloat(colorText.green)/255,
                                         blue: CGFloat(colorText.blue)/255,
                                         alpha: 1/1)
    }
}

// MARK: Keyboard
extension ColorViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        redTextField.inputAccessoryView = doneToolbar
        greenTextField.inputAccessoryView = doneToolbar
        blueTextField.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            redTextField.resignFirstResponder()
            greenTextField.resignFirstResponder()
            blueTextField.resignFirstResponder()
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeColorButton.isHidden = true
        if textField == redTextField{
            redTextField.text = ""
        } else if textField == greenTextField{
            greenTextField.text = ""
        } else if textField == blueTextField{
            blueTextField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let numsLimit = 3

        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace

        return newLength <= numsLimit
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        changeColorButton.isHidden = false
        if textField == redTextField && textField.text != nil{
            if Int(textField.text!) ?? 300 < 256 && Int(textField.text!)! >= 0 {
                redSlider.value = Float(Int(String(redTextField.text!))!)
            } else {
                redTextField.text = String(Int(redSlider.value))
            }
        } else if textField == greenTextField{
            if Int(textField.text!) ?? 300 < 256 && Int(textField.text!)! >= 0 {
                greenSlider.value = Float(Int(String(greenTextField.text!))!)
            } else {
                greenTextField.text = String(Int(greenSlider.value))
            }
        } else if textField == blueTextField{
            if Int(textField.text!) ?? 300 < 256 && Int(textField.text!)! >= 0 {
                blueSlider.value = Float(Int(String(blueTextField.text!))!)
            } else {
                blueTextField.text = String(Int(blueSlider.value))
            }
        }
            
        switch selectedSegmentIndex {
        case 0:
            colorBg = Color(red: Int(redSlider.value),
                            green: Int(greenSlider.value),
                            blue: Int(blueSlider.value))
        case 1:
                colorText = Color(red: Int(redSlider.value),
                                  green: Int(greenSlider.value),
                                  blue: Int(blueSlider.value))
        default:
            return
        }
        updateView()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}



