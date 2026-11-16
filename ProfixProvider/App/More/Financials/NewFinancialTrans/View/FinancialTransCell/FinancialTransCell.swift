//
//  FinancialTransCell.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//

import UIKit

class FinancialTransCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateView: UIView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }

    func setupCell(model : FinancialTransModel ){
        orderIdLabel.text = "#" + "\(model.id ?? 0)"
        createdAtLabel.text = model.date
        stateLabel.text = model.statusText
        
        switch model.status {
        case .pending:
            stateView.backgroundColor = .state
            stateLabel.textColor = .main
            
        case .accepted:
            stateView.backgroundColor = .successView
            stateLabel.textColor = .success
    
        case .refused:
            stateView.backgroundColor = .alphaRed
            stateLabel.textColor = .error
        default:
            break
        }
    }
}
