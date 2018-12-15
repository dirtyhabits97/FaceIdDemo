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
        if ViewController.autoAuthenticate && BiometrictAuthManager.shared.deviceSupportsBiometrics {
            BiometrictAuthManager.shared.requestAuthentication { (result) in
                switch result {
                case .failure(let error): print("Biometric authentication failed: ", error.localizedDescription)
                case .success: print("Biometrict authentication passed!!")
                }
            }
        }
    }
    
    private func setupView() {
        button.setTitle("Test biometrics", for: .normal)
        button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        button.isHidden = !BiometrictAuthManager.shared.deviceSupportsBiometrics
    }
    
    @objc func didPressButton() {
        guard BiometrictAuthManager.shared.deviceSupportsBiometrics else { return }
        BiometrictAuthManager.shared.requestAuthentication { (result) in
            switch result {
            case .failure(let error): print("Biometric authentication failed: ", error.localizedDescription)
            case .success: print("Biometrict authentication passed!!")
            }
        }
    }

}

