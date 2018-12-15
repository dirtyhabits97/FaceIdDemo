//
//  BiometricAuthManager.swift
//  FaceIdDemo
//
//  Created by Gonzalo Reyes Huertas on 12/14/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation
import LocalAuthentication

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public enum BiometrictAuthManagerError: LocalizedError {
    
    case policyEvaluationFailed
    
    public var errorDescription: String? {
        switch self {
        case .policyEvaluationFailed: return "Local Authentication Policy failed"
        }
    }
    
}

public final class BiometrictAuthManager {
    
    public static let shared = BiometrictAuthManager()
    private let context = LAContext()
    
    public var deviceSupportsBiometrics: Bool { return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) }
    
    public func requestAuthentication(completion: @escaping (Result<Void>) -> Void) {
        guard deviceSupportsBiometrics else { return }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Some reason goes here") { (success, error) in
            if let error = error {
                completion(.failure(error))
            } else if success {
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                completion(.failure(BiometrictAuthManagerError.policyEvaluationFailed))
            }
        }
    }
    
}
