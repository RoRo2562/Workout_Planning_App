//
//  ExerciseSetTableViewCell.swift
//  Final-App
//
//  Created by Roro on 5/5/2024.
//

import UIKit

protocol cellTextFieldDelegate{
    func updateExerciseSet(with kgText: Int?, repsText: Int?, for cell:ExerciseSetTableViewCell)
}

class ExerciseSetTableViewCell: UITableViewCell {
    var delegate: cellTextFieldDelegate?
    
    @IBOutlet weak var setNumber: UILabel!
    
    @IBOutlet weak var kgTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    static let indentifier = "ExerciseSetCell"
    
    
    
    
    public func configure(with setIndex: Int, delegate: cellTextFieldDelegate){
        setNumber.text = String(setIndex)
//        kgTextField.delegate = self
//        repsTextField.delegate = self
    }
    
    override func prepareForReuse() {
        kgTextField.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kgTextField.tag = 0
        repsTextField.tag = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ExerciseSetTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.updateExerciseSet(with: Int(self.kgTextField.text ?? "27") ?? 0, repsText: Int(self.repsTextField.text ?? "29") ?? 0, for: self)
    }
}
