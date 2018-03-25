//
//  DetailLoanTableViewCell.swift
//  KivaLoan
//
//  Created by Daniel Davydzik on 25/03/2018.
import UIKit

class DetailLoanTableViewCell: UITableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
