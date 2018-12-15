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

public enum BiometricAuthManagerError: LocalizedError {
    
    case policyEvaluationFailed
    case noAvailableBiometryType
    
    public var errorDescription: String? {
        switch self {
        case .policyEvaluationFailed: return "Local Authentication Policy failed"
        case .noAvailableBiometryType: return "No available biometry type"
        }
    }
    
}

public final class BiometricAuthManager {
    
    public static let shared = BiometricAuthManager()
    
    private let context = LAContext()
    
    public var isAvailable: Bool { return availableBiometryType != .none }
    public var availableBiometryType: BiometryType {
        let isAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        guard isAvailable else { return .none }
        if #available(iOS 11.0, *) {
            return context.biometryType == .faceID ? .faceID : .touchID
        }
        return .touchID
    }
    
    public func requestAuthentication(completion: @escaping (Result<Void>) -> Void) {
        let localizedReason: String
        switch availableBiometryType {
        case .touchID:
            localizedReason = "Touch ID will allow us to authenticate you automatically"
        case .faceID:
            localizedReason = "Face ID will allow us to authenticate you automatically"
        case .none:
            completion(.failure(BiometricAuthManagerError.noAvailableBiometryType))
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { (success, error) in
            if let error = error {
                completion(.failure(error))
            } else if success {
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                completion(.failure(BiometricAuthManagerError.policyEvaluationFailed))
            }
        }
    }
    
}

extension BiometricAuthManager {
    
    public enum BiometryType {
        case touchID
        case faceID
        case none
    }
    
}
