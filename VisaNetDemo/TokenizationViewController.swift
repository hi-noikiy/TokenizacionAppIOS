//
//  CESetUpViewController.swift
//  VisanetCommerceApp
//
//  Created by Luis Perez on 8/30/18.
//  Copyright © 2018 Let Things Happen. All rights reserved.
//

import UIKit
import VisaNetSDK

class CESetUpViewController: UIViewController {
    
    @IBOutlet weak var channelTextField: UITextField!
    @IBOutlet weak var commerceCodeTextField: UITextField!
    @IBOutlet weak var commerceNameTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var colorDisabled: UITextField!
    @IBOutlet weak var fontColor: UITextField!
    @IBOutlet weak var buttonText: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var purchaseNumberTextField: UITextField!
    @IBOutlet weak var backgroundTextField: UITextField!
    @IBOutlet weak var serverResponseUILabel: UITextView!
    
    
    var channels = Config.TK.getChannels()
    var colors = [CEColor(color: .blue, colorName: "Azul"),
                  CEColor(color: .red, colorName: "Rojo"),
                  CEColor(color: .green, colorName: "Verde"),
                  CEColor(color: .lightGray, colorName: "Gris"),
                  CEColor(color: .white, colorName: "Blanco"),
                  CEColor(color: .yellow, colorName: "Amarillo"),
                  CEColor(color: .magenta, colorName: "Magenta"),
                  CEColor(color: .clear, colorName: "Limpio"),
                  CEColor(color: .cyan, colorName: "Cyan")
                ]
    
    class CEColor: NSObject {
        var colorName: String
        var color: UIColor
        init(color: UIColor, colorName: String) {
            self.color = color
            self.colorName = colorName
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.channelTextField.delegate = self
        self.channelTextField.tag = 0
        self.channelTextField.text = "mobile"
        
        self.colorTextField.delegate = self
        self.colorTextField.tag = 1
        self.colorTextField.text = "Azul"
        
        self.backgroundTextField.delegate = self
        self.backgroundTextField.tag = 2
        self.backgroundTextField.text = "Limpio"
        
        
        self.colorDisabled.delegate = self
        self.colorDisabled.tag = 3
        self.colorDisabled.text = "Gris"
        
        self.fontColor.delegate = self
        self.fontColor.tag = 4
        self.fontColor.text = "Blanco"
        
        
        /* TEST ONLY */
        //commerceCodeTextField.text = "341198210"
        commerceCodeTextField.text = "341198210"
        amountTextField.text = "1.00"
        tokenTextField.text = "jode@hotmail.com"
        self.firstNameTextField.text  = "Ethan"
        self.lastNameTextField.text = "Medina"
        self.purchaseNumberTextField.text = "60012"
 
        Config.userCredential = "giancagallardo@gmail.com"
        Config.passwordCredential = "Av3$truz"
        //Config.securityToken = "Z2lhbmNhZ2FsbGFyZG9AZ21haWwuY29tOkF2MyR0cnV6"
        
        /*TEST Prod
         Config.TK.endPointProdURL = "https://apiprod.vnforapps.com"
         Config.TK.type = .prod
         Config.userCredential = "control.visanet@pympack.com.pe"
         Config.passwordCredential = "!92@a?hP"
 */
       
        
        // Header
        //Config.CE.Header.titleText = "Luchito App"
        Config.TK.Header.logoImage = UIImage(named: "icon_logo_apple")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        self.serverResponseUILabel.text = "Server response"
        
        guard let channelRawValue = self.channelTextField.text else { return }
        guard let channel = DataChannelType(rawValue: channelRawValue) else { return }
        print("Canal: ", channel.rawValue)
        
        // Commerce Code
        guard let commerceCode = self.commerceCodeTextField.text else { return }
        if commerceCode.isEmpty {
            showAlert(title: "Falta", message: "Agregue un código de comercio")
            return
        }
        print("Codigo de comercio: ", commerceCode)
        
        
        // Commerce name
        guard let commerceName = self.commerceNameTextField.text else { return }
        print("Nombre de comercio: ", commerceName)
        
        
        // Color
        guard let colorName = self.colorTextField.text else { return }
        guard let color = colors.first(where: { $0.colorName == colorName }) else {
            showAlert(title: "Error", message: "Seleccione color")
            return
        }
        print("Color: ", color.color)
        
        // Monto
        guard let amount = self.amountTextField.text else { return }
        if amount.isEmpty {
            showAlert(title: "Falta", message: "Agregue un monto")
            return
        }
        print("Monto: ", amount)
        
        // Token
        guard let token = self.tokenTextField.text else { return }
        if token.isEmpty {
            showAlert(title: "Falta", message: "Agregue un email como token")
            return
        }
        Config.TK.email = token
        print("Token: ", token)
        
        
        guard let purchaseNumber = self.purchaseNumberTextField.text else { return }
        print("Purchase Number: ", purchaseNumber)
        if purchaseNumber.isEmpty {
            showAlert(title: "Falta", message: "Agregue un Numero de pedido")
            return
        }
        
        
        
        
        // CO first name
        guard let coFirstName = self.firstNameTextField.text else { return }
        print("Nombre de TH: ", coFirstName)
        Config.TK.FirstNameField.defaultText = coFirstName
        
        
        // CO last name
        guard let coLastName = self.lastNameTextField.text else { return }
        print("Apellido de TH: ", coLastName)
        Config.TK.LastNameField.defaultText = coLastName
        
        
        // SEND Values
        Config.TK.dataChannel = channel

        
        // Background Color
        guard let backgroundColor = colors.first(where: { $0.colorName == self.backgroundTextField.text }) else {
            showAlert(title: "Error", message: "Seleccione background color")
            return
        }
        
        // Button Colors
        guard let enabled = colors.first(where: { $0.colorName == self.colorTextField.text }) else {
            showAlert(title: "Error", message: "Seleccione enabled color")
            return
        }
        
        guard let disabled = colors.first(where: { $0.colorName == self.colorDisabled.text }) else {
            showAlert(title: "Error", message: "Seleccione disabled color")
            return
        }
        
        guard let textColor = colors.first(where: { $0.colorName == self.fontColor.text }) else {
            showAlert(title: "Error", message: "Seleccione text color")
            return
        }
        
        Config.TK.formBackground = backgroundColor.color
        Config.TK.AddCardButton.enableColor = enabled.color
        Config.TK.AddCardButton.disableColor = disabled.color
        Config.TK.AddCardButton.titleTextColor = textColor.color
        
        guard let buttonText = self.buttonText.text else { return }
        Config.TK.AddCardButton.titleText = buttonText
        
        
        Config.merchantID = commerceCode
        if !commerceName.isEmpty {
            Config.merchantNameTitle = commerceName
        }
        
        guard let amountValue = Double(amount) else {
            return
        }
        
        Config.amount = amountValue
        
        
        Config.TK.purchaseNumber = purchaseNumber
        
        VisaNet.shared.delegate = self
        _ = VisaNet.shared.presentVisaPaymentForm(viewController: self)
        
        
    }
    
    
    
    
    func addPickerView(textField: UITextField) -> UIPickerView {
        // adding the picker view
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // adding the toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneAction(_:)))
        toolbar.setItems([flexibleBarButtonItem, doneBarButtonItem], animated: true)
        pickerView.tag = textField.tag
        textField.inputView = pickerView
        textField.inputAccessoryView = toolbar
        
        return pickerView
    }
 
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



// MARK: - PickerViewDataSource
extension CESetUpViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case self.channelTextField.tag:
            return self.channels.count
        case self.colorTextField.tag:
            return self.colors.count
        case self.backgroundTextField.tag:
            return self.colors.count
        case self.colorDisabled.tag:
            return self.colors.count
        case self.fontColor.tag:
            return self.colors.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case self.channelTextField.tag:
            return self.channels[row].rawValue
        case self.colorTextField.tag:
            return self.colors[row].colorName
        case self.backgroundTextField.tag:
            return self.colors[row].colorName
        case self.colorDisabled.tag:
            return self.colors[row].colorName
        case self.fontColor.tag:
            return self.colors[row].colorName
        default:
            return ""
        }
    }
    
}

// MARK: - PickerViewDelegate
extension CESetUpViewController : UIPickerViewDelegate {
    
    @objc func doneAction(_ pickerView: UIPickerView) {
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case self.channelTextField.tag:
            self.channelTextField.text = self.channels[row].rawValue
        case self.colorTextField.tag:
            self.colorTextField.text = self.colors[row].colorName
        case self.backgroundTextField.tag:
            self.backgroundTextField.text = self.colors[row].colorName
        case self.colorDisabled.tag:
            self.colorDisabled.text = self.colors[row].colorName
        case self.fontColor.tag:
            self.fontColor.text = self.colors[row].colorName
        default:
            break
        }
    }
    
}

extension CESetUpViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let pickerViewText = textField.text else { return }
        
        let pickerView = self.addPickerView(textField: textField)
        
        switch textField {
        case self.channelTextField:
            if pickerViewText.isEmpty {
                textField.text = channels.first?.rawValue
            }
            else {
                if let channelFound = DataChannelType(rawValue: pickerViewText) {
                    guard let index = self.channels.firstIndex(of: channelFound) else {
                        return
                    }
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                }
            }
        case self.colorTextField:
            if pickerViewText.isEmpty {
                textField.text = colors.first?.colorName
            }
            else {
                if let colorFound = colors.first(where: { $0.colorName == pickerViewText }) {
                    guard let index = self.colors.firstIndex(of: colorFound) else {
                        return
                    }
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                }
            }
        case self.backgroundTextField:
            if pickerViewText.isEmpty {
                textField.text = colors.first?.colorName
            }
            else {
                if let colorFound = colors.first(where: { $0.colorName == pickerViewText }) {
                    guard let index = self.colors.firstIndex(of: colorFound) else {
                        return
                    }
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                }
            }
        case self.colorDisabled:
            if pickerViewText.isEmpty {
                textField.text = colors.first?.colorName
            }
            else {
                if let colorFound = colors.first(where: { $0.colorName == pickerViewText }) {
                    guard let index = self.colors.firstIndex(of: colorFound) else {
                        return
                    }
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                }
            }
        case self.fontColor:
            if pickerViewText.isEmpty {
                textField.text = colors.first?.colorName
            }
            else {
                if let colorFound = colors.first(where: { $0.colorName == pickerViewText }) {
                    guard let index = self.colors.firstIndex(of: colorFound) else {
                        return
                    }
                    pickerView.selectRow(index, inComponent: 0, animated: false)
                }
            }
        default:
            break
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let pickerView = textField.inputView as? UIPickerView
        switch textField {
        case self.channelTextField:
            textField.text = channels[(pickerView?.selectedRow(inComponent: 0))!].rawValue
        case self.colorTextField:
            textField.text = colors[(pickerView?.selectedRow(inComponent: 0))!].colorName
        case self.backgroundTextField:
            textField.text = colors[(pickerView?.selectedRow(inComponent: 0))!].colorName
        case self.colorDisabled:
            textField.text = colors[(pickerView?.selectedRow(inComponent: 0))!].colorName
        case self.fontColor:
            textField.text = colors[(pickerView?.selectedRow(inComponent: 0))!].colorName
        default: break
            
        }
        
    }
    
}
 

extension CESetUpViewController : VisaNetDelegate {
   
    func registrationDidEnd(serverError: Any?, responseData: Any?) {
        var message = ""
        if serverError == nil {
            message = "DATA: \(String(describing: responseData))"
        } else {
            message = "ERROR: \(String(describing: serverError))"
        }
        print(message)
        self.serverResponseUILabel.text = message
        
    }
}

extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}
