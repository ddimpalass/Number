//
//  ViewController.swift
//  Number
//
//  Created by Apple on 14.12.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    private var firstNumber = 0
    private var secondeNumber = 0
    private var number = 0
    private var mathSign = "+"
    private var result = 0
    
    private var userResult = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewExample()
    }
    
    @IBAction func selectorMatSign(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mathSign = "+"
            
        case 1:
            mathSign = "-"
            
        case 2:
            mathSign = "*"
            
        case 3:
            mathSign = "/"
            
        default:
            return
        }
        getNewExample()
    }

    @IBAction func numberTapped(_ sender: Any) {
        guard userResult.count < 3 else { return }
        userResult += (sender as AnyObject).titleLabel?.text ?? ""
        answerLabel.text = userResult
    }
    
    @IBAction func deleteNumberButton(_ sender: Any) {
        guard  !userResult.isEmpty else { return }
        if userResult.count < 2 {
            userResult.removeLast()
            answerLabel.text = "Введите значение"
        } else {
            userResult.removeLast()
            answerLabel.text = userResult
        }
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        getNewExample()
    }
    
    @IBAction func checkResultTapped(_ sender: Any) {
        if checkResult(firstNumber: firstNumber, secondeNumber: secondeNumber) {
            showAlert(title: "Поздравляем",
                      message: "Это правильное решение",
                      action: .resultTrue)
        } else if answerLabel.text == "Введите значение" {
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

extension ViewController{
    func checkResult(firstNumber: Int, secondeNumber: Int) -> Bool{
        if Int(userResult) == result{
            return true
        } else {
            return false
        }
    }
}

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
                self.answerLabel.text = "Введите значение"
                self.userResult = ""
                self.getNewExample()
            }
        case .resultFalse:
            okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.answerLabel.text = "Введите значение"
                self.userResult = ""
            }
        }
    
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

extension ViewController{
    private func getNewExample(){
        switch mathSign {
        case "+":
            firstNumber = Int.random(in: 0..<100)
            secondeNumber = Int.random(in: 0..<100)
            result = firstNumber + secondeNumber
        case "-":
            firstNumber = Int.random(in: 2..<100)
            secondeNumber = Int.random(in: 0..<firstNumber)
            result = firstNumber - secondeNumber
        case "*":
            firstNumber = Int.random(in: 1..<10)
            secondeNumber = Int.random(in: 1..<10)
            result = firstNumber * secondeNumber
        case "/":
            number = Int.random(in: 1..<10)
            firstNumber = number * Int.random(in: 1..<10)
            secondeNumber = number
            result = firstNumber / secondeNumber
        default:
            return
        }
        exampleLabel.text = "Решите пример: \(firstNumber) \(mathSign) \(secondeNumber)"
    }
}
