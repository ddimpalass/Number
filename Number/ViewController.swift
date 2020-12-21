//
//  ViewController.swift
//  Number
//
//  Created by Apple on 14.12.2020.
//

import UIKit

class ViewController: UIViewController{

    // MARK: - IB Outlets
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet var numPad: [UIButton]!
    
    
    // MARK: - Private properties
    private var firstNumber = 0
    private var secondeNumber = 0
    private var number = 0
    private var mathSign = "+"
    private var result = 0
    private var userResult = ""
    private var selectedSegmentIndex = 0
    
    // MARK: - Properties
    var colorBg: Color = Color(red: 255,
                               green: 255,
                               blue: 255)
    var colorText: Color = Color(red: 85,
                                 green: 85,
                                 blue: 85)
    
    var uiColorBg: UIColor = .white
    var uiColorText: UIColor = .darkGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNumbersAndSign(selectedSegmentIndex: selectedSegmentIndex)
    }
    
    // MARK: - IB Actions
    @IBAction func selectorMatSign(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        getNumbersAndSign(selectedSegmentIndex: selectedSegmentIndex)
    }

    @IBAction func numberTapped(_ sender: Any) {
        guard userResult.count < 3 else { return }
        userResult += (sender as AnyObject).titleLabel?.text ?? ""
        answerLabel.text = userResult
    }
    
    @IBAction func colorSettingButton(_ sender: UIButton) {
    }
    
    @IBAction func deleteNumberButton(_ sender: Any) {
        guard  !userResult.isEmpty else { return }
        if userResult.count < 2 {
            userResult.removeLast()
            answerLabel.text = "Ответ"
        } else {
            userResult.removeLast()
            answerLabel.text = userResult
        }
    }
    
    @IBAction func checkResultTapped(_ sender: Any) {
        if checkResult(firstNumber: firstNumber, secondeNumber: secondeNumber) {
            showAlert(title: "Поздравляем",
                      message: "Это правильное решение",
                      action: .resultTrue)
        } else if answerLabel.text == "Ответ" {
            showAlert(title: "Пустое поле",
                      message: "Введите значение",
                      action: .resultFalse)
        } else {
            showAlert(title: "Жаль",
                      message: "Это неверное решение",
                      action: .resultFalse)
        }
    }
}

// MARK: - Get and set new color
extension ViewController: ColorViewControllerDelegate{
    func getNewColor(_ colorBg: Color, _ colorText: Color){
        
        uiColorBg = UIColor(red: CGFloat(colorBg.red)/255,
                            green: CGFloat(colorBg.green)/255,
                            blue: CGFloat(colorBg.blue)/255,
                            alpha: 1/1)
        uiColorText = UIColor(red: CGFloat(colorText.red)/255,
                              green: CGFloat(colorText.green)/255,
                              blue: CGFloat(colorText.blue)/255,
                              alpha: 1/1)
        
        view.backgroundColor = uiColorBg
        exampleLabel.textColor = uiColorText
        answerLabel.textColor = uiColorText
        numPad.forEach{
            $0.tintColor = uiColorText
        }
        checkButton.setTitleColor(uiColorBg, for: .normal)
        checkButton.backgroundColor = uiColorText
            
        self.colorBg = colorBg
        self.colorText = colorText
    }
}


// MARK: - Navigation
extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let colorVC = segue.destination as! ColorViewController
        colorVC.delegate = self
        colorVC.colorBg = colorBg
        colorVC.colorText = colorText
    }
}

// MARK: - Check result
extension ViewController{
    func checkResult(firstNumber: Int, secondeNumber: Int) -> Bool{
        if Int(userResult) == result{
            return true
        } else {
            return false
        }
    }
}

// MARK: - Alerts
extension ViewController{
    enum alertType{
        case resultTrue
        case resultFalse
    }
    
    private func showAlert(title: String, message: String, action: alertType){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction: UIAlertAction
        
        switch action {
        case .resultTrue:
            okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.answerLabel.text = "Ответ"
                self.userResult = ""
                self.getNumbersAndSign(selectedSegmentIndex: self.selectedSegmentIndex)
            }
        case .resultFalse:
            okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.answerLabel.text = "Ответ"
                self.userResult = ""
            }
        }
    
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

// MARK: - Get numbers and sign
extension ViewController{
    private func getNumbersAndSign(selectedSegmentIndex: Int){
        switch selectedSegmentIndex {
        case 0:
            firstNumber = Int.random(in: 0..<100)
            secondeNumber = Int.random(in: 0..<100)
            mathSign = "+"
            result = firstNumber + secondeNumber
        case 1:
            firstNumber = Int.random(in: 2..<100)
            secondeNumber = Int.random(in: 0..<firstNumber)
            mathSign = "-"
            result = firstNumber - secondeNumber
        case 2:
            firstNumber = Int.random(in: 1..<10)
            secondeNumber = Int.random(in: 1..<10)
            mathSign = "x"
            result = firstNumber * secondeNumber
        case 3:
            number = Int.random(in: 1..<10)
            firstNumber = number * Int.random(in: 1..<10)
            secondeNumber = number
            mathSign = "/"
            result = firstNumber / secondeNumber
        default:
            return
        }
        getNewExample()
    }
}

// MARK: - Get new examples
extension ViewController{
    private func getNewExample(){
        exampleLabel.text = "Решите пример: \(firstNumber) \(mathSign) \(secondeNumber)"
    }
}
