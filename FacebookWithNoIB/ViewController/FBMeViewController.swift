//
//  FBMeViewController.swift
//  FacebookWithNoIB
//
//  Created by Nitin Kalokhe on 21/05/23.
//

import UIKit

class FBMeViewController:FBMeBaseViewController {
    
    typealias RowModel = [String: String]
    
    fileprivate var user:FBMeUser {
        get {
            return FBMeUser(name: "Nitin", avatarName: "Avatar Name", education: "Engineering")
        }
    }
    
    fileprivate var tableViewDataSource:[[String:Any]]{
        get {
            return TableKeys.populate(withUser: user)
        }
    }
    
    private let tableView:UITableView = {
        let view = UITableView()
        view.register(FBMeBaseCell.self, forCellReuseIdentifier: FBMeBaseCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Facebook"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        // Set layout for tableview
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Specs.color.tint
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["tableView": tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["tableView": tableView]))
    }
    
    fileprivate func rows(at section:Int) ->[Any]{
        return tableViewDataSource[section][TableKeys.Rows] as! [Any]
    }
    
    fileprivate func titles(at section:Int) ->String? {
        return tableViewDataSource[section][TableKeys.Section] as? String
    }
    
    fileprivate func rowModel(as indexPath:IndexPath) -> RowModel{
        return rows(at: indexPath.section)[indexPath.row] as! RowModel
    }
}

extension FBMeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView:UITableView) -> Int {
        return tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows(at: section).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modelForRow = rowModel(as: indexPath)
        var cell = UITableViewCell()
        
        guard let title = modelForRow[TableKeys.Title] else {
            return cell
        }
        
        if title == user.name {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: FBMeBaseCell.identifier, for: indexPath)
        }
        
        cell.textLabel?.text = title
        
        if let imageName = modelForRow[TableKeys.ImageName] {
            cell.imageView?.image = UIImage(named: imageName)
        } else if title != TableKeys.logout {
            cell.imageView?.image = UIImage(named: Specs.imageName.placeholder)
        }
        
        if title == user.name {
            cell.detailTextLabel?.text = modelForRow[TableKeys.SubTitle]
        }
        
        return cell
    }
    
    
}

extension FBMeViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let modelForRow = rowModel(as: indexPath)
        
        guard let title = modelForRow[TableKeys.Title] else {
            return 0.0
        }
        
        if title == user.name {
            return 64.0
        } else {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let modelForRow = rowModel(as: indexPath)
        
        guard let title = modelForRow[TableKeys.Title] else {
            return
        }
        
        if title == TableKeys.seeMore || title == TableKeys.addFavorites {
            cell.textLabel?.textColor = Specs.color.tint
            cell.accessoryType = .none
        } else if title == TableKeys.logout {
            cell.textLabel?.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            cell.textLabel?.textColor = Specs.color.red
            cell.textLabel?.textAlignment = .center
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }
    }
    
    
}
