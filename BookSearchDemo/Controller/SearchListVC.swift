//
//  SearchListVC.swift
//  BookSearchDemo
//
//  Created by Ejaz on 15/03/22.
//

import UIKit

class SearchListVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variable
    var arrSearchedData = [SearchedDatabaseModel]()
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        arrSearchedData.isEmpty ? tableView.setEmptyMessage("No search results found") : tableView.restoreEmptyMessage()
        navigationItem.rightBarButtonItem = .init(title: "Cancel", style: .done, target: self, action: #selector(dismissVC))
    }
    
    
    //MARK: Click actions
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension SearchListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrSearchedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableCell")!
        let obj = arrSearchedData[indexPath.row]
        if obj.first_publish_year?.str.isEmpty ?? true {
            cell.textLabel?.text = obj.title
        } else {
            cell.textLabel?.text = obj.title?.appending(" ").appending("(\(obj.first_publish_year?.str ?? ""))")
        }
        if !(obj.author_name?.first?.isEmpty ?? true) {
            cell.detailTextLabel?.text = "By \(obj.author_name!.first!)"
        } else {
            cell.detailTextLabel?.text = " "
        }
        return cell
    }
    
}
