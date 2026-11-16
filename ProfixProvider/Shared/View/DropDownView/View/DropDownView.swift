//
//  DropDownView.swift
//  Waraqa
//
//  Created by Haneen on 04/08/2025.
//

import UIKit

class DropDownView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var txtFieldStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableStackView: UIStackView!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var containerStack: UIStackView!
    
    //MARK: - Properties -
    
    var isRequired  = true
    var items : [SelectionModel] = []
    var delegate : DropDownViewDelegate?
    
    var isCellExpanded = false {
        didSet {
            handleExbandCollapseCell()
        }
    }
    
    @IBInspectable var isRequiredProperty : Bool = true {
        didSet{
            isRequired = isRequiredProperty
            if isRequired {
                requiredLabel.textColor = .black
            } else {
                requiredLabel.textColor = UIColor.border
            }
        }
    }
    
    @IBInspectable var titleTxt : String = "" {
        didSet{
            titleLabel.text = titleTxt.localized
        }
    }
    
    @IBInspectable var requiredTxt : String = "" {
        didSet{
            requiredLabel.text = requiredTxt.localized
        }
    }
    
    @IBInspectable var placeHolderTxt : String = "" {
        didSet{
            txtField.placeholder = placeHolderTxt.localized
        }
    }
    
    @IBInspectable var isLabelHidden : Bool = false {
        didSet{
            requiredLabel.isHidden = isLabelHidden
        }
    }
    
    
    @IBInspectable var viewBackgroundColor : UIColor? {
        didSet{
            containerView.backgroundColor = viewBackgroundColor
        }
    }
    
    @IBInspectable var stackBackgroundColor : UIColor? {
        didSet{
            txtFieldStackView.backgroundColor = stackBackgroundColor
            containerStack.backgroundColor = stackBackgroundColor
        }
    }
    
    @IBInspectable var stackBorderColor : UIColor? {
        didSet{
            containerStack.layer.borderColor = stackBorderColor?.cgColor
            containerStack.layer.borderWidth = 1
            containerStack.layer.masksToBounds = true
        }
    }

    //MARK: - Initializer -
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        configureView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        setupView()
    }
    
    //MARK: - Nib file configuration -
    
    func loadViewFromNib(nibName:String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "DropDownView")
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    //MARK: - View Setup -
    
    func setupView() {
        txtFieldStackView.layer.borderColor = UIColor.clear.cgColor
        txtFieldStackView.layer.borderWidth = 1
        txtFieldStackView.layer.masksToBounds = true
        configureTableView()
    }
    
    func getTableData(items : [SelectionModel],isCellExpanded : Bool) {
        self.items = items
        self.isCellExpanded = isCellExpanded
        tableView.reloadData()
    }
    
    func handleExbandCollapseCell() {
        if isCellExpanded {
            tableStackView.isHidden = false
            tableView.reloadData()
            tableView.layoutIfNeeded()
            tableStackView.layoutIfNeeded()
            arrowIcon.image = UIImage(named: "arrowIconUp")
            txtFieldStackView.layer.borderColor = UIColor.textFieldBorder.cgColor

        } else {
            tableStackView.isHidden = true
            arrowIcon.image = UIImage(named: "arrow-down-01-round")
            txtFieldStackView.layer.borderColor = UIColor.clear.cgColor

        }
    }
}

//MARK: - TableView Configuration -

extension DropDownView : UITableViewDelegate , UITableViewDataSource {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: DropDownViewCell.self, bundle: nil)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: DropDownViewCell.self, for: indexPath)
        cell.setupCell(title: items[indexPath.row].name, cellBackgroundColor: stackBackgroundColor ?? .white)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.didSelectItem(item: item)
    }
}


//MARK: - DropDownView Protocol -

protocol DropDownViewDelegate : AnyObject {
    func didSelectItem(item : SelectionModel)
}
