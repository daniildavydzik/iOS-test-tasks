//
//  KivaLoanTableViewCell.swift
//  KivaLoan
//
//  Created by Daniel Davydzik on 24/03/2018.
import UIKit

class KivaLoanTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var countryLabel:UILabel!
    @IBOutlet weak var useLabel:UILabel!
    @IBOutlet weak var amountLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(loan : LoanMO)  {
        DispatchQueue.main.async {
            self.nameLabel.text = loan.name
            self.countryLabel.text = loan.country
            self.useLabel.text = loan.use
            self.amountLabel.text = String(loan.loan_amount)
        }
        
    }

}
