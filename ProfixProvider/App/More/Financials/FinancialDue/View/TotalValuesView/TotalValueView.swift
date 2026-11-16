//
//  TotalValueView.swift
//  ProfixProvider
//
//  Created by Haneen on 07/02/2026.
//

import UIKit

class TotalValueView: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properites -
     
    var orderDataList : [OrderDataModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }

    func setupCell(model : TotalValuesModel?){
        guard let model = model else { return }
        orderDataList = model.getTotalValuesList()
        tableView.reloadData()
    }
}

//MARK: - TableView Configuration -

extension TotalValueView : UITableViewDataSource, UITableViewDelegate {

    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: TotalValuesCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: TotalValuesCell.self, for: indexPath)
        let item = orderDataList[indexPath.row]
        let isLast = indexPath.row == (orderDataList.count - 1)
        cell.setupCell(model: item, isLast: isLast)
        return cell
    }
}
