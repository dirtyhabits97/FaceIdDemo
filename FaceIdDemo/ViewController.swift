//
//  ViewController.swift
//  FaceIdDemo
//
//  Created by Gonzalo Reyes Huertas on 12/14/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var button: UIButton!
    public static var autoAuthenticate: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ViewController.autoAuthenticate {
            BiometricAuthManager.shared.requestAuthentication { (result) in
                switch result {
                case .failure(let error): print("Biometric authentication failed: ", error.localizedDescription)
                case .success: print("Biometrict authentication passed!!")
                }
            }
        }
    }
    
    private func setupView() {
        button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        switch BiometricAuthManager.shared.availableBiometryType {
        case .none:
            button.isHidden = true
        case .faceID:
            button.setTitle("Test face id", for: .normal)
            button.isHidden = false
        case .touchID:
            button.setTitle("Test touch id", for: .normal)
            button.isHidden = false
        }
    }
    
    @objc func didPressButton() {
        BiometricAuthManager.shared.requestAuthentication { (result) in
            switch result {
            case .failure(let error): print("Biometric authentication failed: ", error.localizedDescription)
            case .success: print("Biometrict authentication passed!!")
            }
        }
    }

}

