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

// MARK: Hide keyboard
extension ColorViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


// MARK: Keyboard
extension ColorViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if textField == redTextField{
            redSlider.value = Float(Int(String(redTextField.text ?? "255")) ?? 255)
        } else if textField == greenTextField{
            greenSlider.value = Float(Int(String(greenTextField.text ?? "255")) ?? 255)
        } else if textField == blueTextField{
            blueSlider.value = Float(Int(String(blueTextField.text ?? "255")) ?? 255)
        }
        
        switch selectedSegmentIndex {
        case 0:
            colorBg = Color(red: Int(redSlider.value), green: Int(greenSlider.value), blue: Int(blueSlider.value))
        case 1:
            colorText = Color(red: Int(redSlider.value), green: Int(greenSlider.value), blue: Int(blueSlider.value))
        default:
            return
        }
        
        updateView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: Keyboard done button
extension ColorViewController{
    @objc func keyboardWillShow(notification: NSNotification) {
        changeColorButton.isHidden = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        changeColorButton.isHidden = false
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
    




