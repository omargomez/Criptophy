//
//  ViewController.swift
//  CriptophySample
//
//  Created by Omar Eduardo Gomez Padilla on 2/7/19.
//  Copyright © 2019 Omar Eduardo Gomez Padilla. All rights reserved.
//

import UIKit
import Criptophy

class ViewController: UIViewController {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var outText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onEncryptAction(_ sender: Any) {
        
        guard let text = inputText.text, text.count > 0 else {
            return
        }
        
        let outData = Cipher.shared.encrypt(text.data(using: .utf8)!)!
        let outData64 = outData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        let outString = String(data: outData64, encoding: String.Encoding.utf8) ?? "Error"

        self.outText.text = outString
    }
    
}

