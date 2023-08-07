//
//  PhotoListHeaderView.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit

protocol PhotoListHeaderViewDelegate: AnyObject {
    func historyViewDidChangeState(_ requestedHeight: CGFloat)
    func historyViewDidSearch(query: String)
}

final class PhotoListHeaderView: UIView {
    
    private let historyTable = UITableView()
    private let searchTextField = PaddingTextField()
    private let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    
    private let itemHeight = 45.0
    private let allwaysWisibleHeight = 55.0
    
    private var queryItems: [String] = []
    
    weak var delegate: PhotoListHeaderViewDelegate?
    private var contentHeight: CGFloat {
        allwaysWisibleHeight + min(4.5, Double(queryItems.count)) * itemHeight // 4.5 cells max
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupConstraints()
        setupUI()
    }
    
    private func setupConstraints() {
        [searchTextField, historyTable, icon].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        })
        
        let viewsDict = [
            "searchTextField" : searchTextField,
            "historyTable" : historyTable,
            "icon" : icon,
        ] as [String : Any]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[searchTextField(45)]|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[icon(35)]|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[searchTextField]-5-[historyTable]-0-|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(allwaysWisibleHeight)-[historyTable]-0-|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[icon(45)]-5-[searchTextField]-6-|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-6-[historyTable]-6-|", options: [], metrics: nil, views: viewsDict))
    }
    
    private func setupUI() {
        icon.tintColor = .lightGray
        icon.contentMode = .scaleAspectFit
        
        historyTable.delegate = self
        historyTable.dataSource = self
        historyTable.backgroundColor = .clear
        historyTable.layer.cornerRadius = 10
        historyTable.layer.masksToBounds = true
        historyTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        backgroundColor = .clear
        searchTextField.backgroundColor = .lightGray
        searchTextField.textColor = .white
        searchTextField.layer.cornerRadius = 10
        searchTextField.inset = 15
        searchTextField.layer.masksToBounds = true
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        searchTextField.clearButtonMode = .always
        searchTextField.placeholder = "Search"
    }
    
    func setSearchText(_ search: String?) {
        searchTextField.text = search
    }
}

extension PhotoListHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let query = textField.text ?? ""
        delegate?.historyViewDidSearch(query: query)
        if !query.isEmpty {
            queryItems.append(query)
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        historyTable.reloadData()
        delegate?.historyViewDidChangeState(contentHeight)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.historyViewDidChangeState(allwaysWisibleHeight)
    }
}

extension PhotoListHeaderView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        itemHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        queryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = queryItems[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .lightGray
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let queryItem = queryItems[indexPath.row]
        searchTextField.text = queryItem
        searchTextField.resignFirstResponder()
        delegate?.historyViewDidSearch(query: queryItem)
    }
    
}
