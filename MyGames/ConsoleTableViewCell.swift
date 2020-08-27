//
//  ConsoleTableViewCell.swift
//  MyGames
//
//  Created by tamires.p.silva on 26/08/20.
//  Copyright © 2020 Tamires. All rights reserved.
//

import UIKit

class ConsoleTableViewCell: UITableViewCell {

    @IBOutlet weak var ivConsole: UIImageView!
    @IBOutlet weak var lbConsole: UILabel!
    
    var console: Console?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func prepare(with console: Console) {
        lbConsole.text = console.name ?? ""
        if let image = console.cover as? UIImage {
            ivConsole.image = image
        } else {
            ivConsole.image = UIImage(named: "noCover")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
