//
//  ExerciseSetTableViewCell.swift
//  Final-App
//
//  Created by Roro on 5/5/2024.
//

import UIKit

class ExerciseSetTableViewCell: UITableViewCell {
    @IBOutlet weak var setNumber: UIButton!
    
    @IBOutlet weak var kgTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    static let indentifier = "ExerciseSetCell"
    
    static func nib() -> UINib {
        return UINib(nibName: indentifier, bundle: nil)
    }
    
    public func configure(setIndex: Int){
        setNumber.titleLabel?.text = String(setIndex)
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
