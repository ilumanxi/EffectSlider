//
//  ViewController.swift
//  EffectSlider
//
//  Created by 风起兮 on 2022/3/21.
//

import UIKit



class ViewController: UIViewController {
    
    
    @IBOutlet weak var effectSlider: EffectSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        effectSlider.layer.borderColor = UIColor.red.cgColor
        effectSlider.layer.borderWidth = 1
        effectSlider.addTarget(self, action: #selector(valueDidChanned), for: .valueChanged)
        effectSlider.percentage = 0.5
        
        
        
        
    }


    
    @objc private func valueDidChanned(_ sender: EffectSlider) {
        print(sender.percentage)
    }
}

