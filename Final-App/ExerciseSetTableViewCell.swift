//
//  ExerciseSetTableViewCell.swift
//  Final-App
//
//  Created by Roro on 5/5/2024.
//

import UIKit

class ExerciseSetTableViewCell: UITableViewCell {
    @IBOutlet weak var setNumber: UILabel!
    
    @IBOutlet weak var kgTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    static let indentifier = "ExerciseSetCell"
    
    
    public func configure(with setIndex: Int){
        setNumber.text = String(setIndex)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
