//
//  FinancialBreakdownView.swift
//  ProfixProvider
//
//  Created by Haneen on 06/02/2026.
//

import UIKit

class FinancialBreakdownView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var orderCostLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    @IBOutlet weak var commissionLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    //MARK: - Properites -
     
    
    //MARK: - Initializer -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetup()
    }
    
    //MARK: - Nib file configuration -
    
    func viewSetup(){
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
        
    func loadViewFromNib()-> UIView {
        let nib = UINib(nibName: "FinancialBreakdownView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
        
    func getDataSource(model : FinancialOrders){
        orderNumLabel.text = "order_number".localized + "#\(model.orderNum ?? 0)"
        dateLabel.text = model.time
        orderCostLabel.text = model.orderPrice?.toPrice
        taxValueLabel.text = model.orderAddedValue?.toPrice
        commissionLabel.text = model.orderAppPercentage?.toPrice
        totalLabel.text = model.orderTotalPrice?.toPrice
    }
}
