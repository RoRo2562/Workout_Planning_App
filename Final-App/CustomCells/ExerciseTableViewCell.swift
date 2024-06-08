//
//  ExerciseTableViewCell.swift
//  Final-App
//
//  Created by Roro on 21/5/2024.
//

import UIKit
protocol ExerciseTableViewCellDelegate: ExerciseTableViewCell {
    func cell(_ cell: ExerciseTableViewCell, didTap button: UIButton)
}

class ExerciseTableViewCell: UITableViewCell {
    weak var delegate: ExerciseTableViewCellDelegate?
    
    @IBAction func didTapButton(_ button: UIButton) {
            delegate?.cell(self, didTap: button)
    }
    
    func configure(text: String, delegate: ExerciseTableViewCellDelegate) {
            self.textLabel?.text = text
            self.delegate = delegate
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
