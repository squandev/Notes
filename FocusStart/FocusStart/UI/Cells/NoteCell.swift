//
//  NoteCell.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/19/21.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var mainText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.text = ""
        mainText.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
