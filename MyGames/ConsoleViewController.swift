//
//  ConsoleViewController.swift
//  MyGames
//
//  Created by tamires.p.silva on 26/08/20.
//  Copyright © 2020 Tamires. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {

    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var ivConsole: UIImageView!
    
    var console: Console?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbConsole.text = console?.name
        
        if let image = console?.cover as? UIImage {
            ivConsole.image = image
        } else {
            ivConsole.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditConsoleViewController
        vc.console = console
    }
}
