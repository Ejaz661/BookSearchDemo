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
        view.endEditing(true)
        guard !(txtSearch.text?.isEmpty ?? true) else {
            print("Please enter data")
            return
        }
        
        let searchStr = txtSearch.text!.replacingOccurrences(of: " ", with: "+")
        let arr = DBManager.shared.getData(for: searchStr)
        if !arr.isEmpty {
            goToDeatilVC(data: arr)
        } else {
            apiSearch(searchStr: searchStr)
        }
    }
    
    //MARK: Custom methods
    
    /// Make a request to server and get search results
    /// - Parameter searchStr: Search string
    func apiSearch(searchStr: String) {
        ShowHUD()
        var comp = URLComponents(string: "https://openlibrary.org/search.json")!
        comp.queryItems = [
            .init(name: "q", value: searchStr),
            .init(name: "limit", value: "10")
        ]
        
        ApiManager.shared.makeRequest(request: URLRequest(url: comp.url!.absoluteURL)) { (result:Result<GeneralModel,Error>) in
            HideHUD()
            switch result {
                case .success(let resp):
                    DBManager.shared.addData(array: resp.docs, for: searchStr)
                    self.goToDeatilVC(data: resp.docs)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    /// Open detail screen to show search result
    /// - Parameter data: Array of search result
    func goToDeatilVC(data: [SearchedDatabaseModel]) {
        DispatchQueue.main.async {
            let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "SearchListVC") as! SearchListVC
            vc.arrSearchedData = data
            vc.title = data.first?.searched?.replacingOccurrences(of: "+", with: " ")
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }
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

