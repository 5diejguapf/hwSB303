//
//  FortsCellView.swift
//  hwSB303
//
//  Created by serg on 16.07.2023.
//

import UIKit


final class FortsCellView: UITableViewCell {
    
    @IBOutlet weak var longName: UILabel!
    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var stepPrice: UILabel!
    @IBOutlet weak var prevPrice: UILabel!
    @IBOutlet weak var buySellFee: UILabel!
    @IBOutlet weak var minStep: UILabel!
    @IBOutlet weak var expDate: UILabel!
    
    func configure(with fortsSec: IssFortsSecurityInfo, marketdata: IssFortsMarketInfo) {
        shortName.text = fortsSec.shortname
        longName.text = fortsSec.secname
        
        func doubleToString(_ value: Double?) -> String {
            if let value = value {
                return String(value)
            } else {
                return "-"
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        stepPrice.text = doubleToString(fortsSec.stepprice)
        prevPrice.text = doubleToString(marketdata.last)
        buySellFee.text = doubleToString(fortsSec.buysellfee)
        minStep.text = doubleToString(fortsSec.minstep)
        if let lastDate = fortsSec.lastdeldate {
            expDate.text = dateFormatter.string(from: lastDate)
        } else {
            expDate.text = "-"
        }
    }
}
