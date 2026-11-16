//
//  LastCell.swift
//  Profix
//
//  Created by Haneen on 22/12/2025.
//

import UIKit

class LastCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    //MARK: - Properties -
    
    var delegate : LastCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : MoreMenuItem){
        cellIcon.image = UIImage(named: model.icon)
        cellLabel.text = model.title
        notificationSwitch.isOn = UserDefaults.isNotify
        notificationSwitch.isHidden = model.isNotifyHidden
    }
    
    @IBAction func didTapNotification(_ sender: UISwitch) {
        delegate?.onSwitchValueChanged()
    }
}

//MARK: - Delegation -
protocol LastCellProtocol {
    func onSwitchValueChanged()
}
