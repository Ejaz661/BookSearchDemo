//
//  LandingVC.swift
//  BookSearchDemo
//
//  Created by Ejaz on 14/03/22.
//

import UIKit

class LandingVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnOkay: UIButton!
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.btnOkay.layer.cornerRadius = 5
            self.btnOkay.clipsToBounds = true
        }
    }
    
    //MARK: Click actions
    @IBAction func btnOkayClicked(_ sender: UIButton) {
    }
    
}

//MARK: UITextFieldDelegate
extension LandingVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let isEmpty = newString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        btnOkay.isEnabled = !isEmpty
        btnOkay.alpha = isEmpty ? 0.5 : 1
        return (newString as NSString).rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
    
}

