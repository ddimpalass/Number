//
//  ColorViewController.swift
//  Number
//
//  Created by Apple on 18.12.2020.
//

import UIKit

class ColorViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet weak var viewRGBA: UIView!
    @IBOutlet weak var redLabelValue: UILabel!
    @IBOutlet weak var greenLabelValue: UILabel!
    @IBOutlet weak var blueLabelValue: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redSlider.minimumValue = 0
        redSlider.maximumValue = 255
        redSlider.value = 255
        
        greenSlider.minimumValue = 0
        greenSlider.maximumValue = 255
        greenSlider.value = 255
        
        blueSlider.minimumValue = 0
        blueSlider.maximumValue = 255
        blueSlider.value = 255
    }
    
    // MARK: - IB Actions
    @IBAction func changeColor(_ sender: UIButton) {
        redLabelValue.text = String(Int(redSlider.value))
        greenLabelValue.text = String(Int(greenSlider.value))
        blueLabelValue.text = String(Int(blueSlider.value))
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        redLabelValue.text = String(Int(redSlider.value))
        greenLabelValue.text = String(Int(greenSlider.value))
        blueLabelValue.text = String(Int(blueSlider.value))
        
        viewRGBA.backgroundColor = UIColor(red: CGFloat(redSlider.value/255),
                                           green: CGFloat(greenSlider.value/255),
                                           blue: CGFloat(blueSlider.value/255),
                                           alpha: CGFloat(1/1))
    }
}
