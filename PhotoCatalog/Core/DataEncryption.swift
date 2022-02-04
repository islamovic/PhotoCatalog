//
//  DataEncryption.swift
//  PhotoCatalog
//
//  Created by Islam on 03/02/2022.
//

import Foundation
import CryptoKit

class DataEncryption {

    func generatePrivateKey() -> P256.KeyAgreement.PrivateKey {
        let privateKey = P256.KeyAgreement.PrivateKey()
        return privateKey
    }

    // User export Private key to convert private key object to string to store it in keychain.
    func exportPrivateKey(_ privateKey: P256.KeyAgreement.PrivateKey) -> String? {
        let rawPrivateKey = privateKey.rawRepresentation
        let privateKeyBase64 = rawPrivateKey.base64EncodedString()
        guard let percentEncodedPrivateKey = privateKeyBase64.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }
        return percentEncodedPrivateKey
    }

    // Imported Private key used to get the private key object from string
    func importPrivateKey(_ privateKey: String) throws -> P256.KeyAgreement.PrivateKey? {
        guard let privateKeyBase64 = privateKey.removingPercentEncoding else { return nil }
        guard let rawPrivateKey = Data(base64Encoded: privateKeyBase64) else { return nil }
        return try? P256.KeyAgreement.PrivateKey(rawRepresentation: rawPrivateKey)
    }

    // Use Diffie-Hellman Key Exchange to generate the symmetric key.
    func driveSymmetricKey(privateKey: P256.KeyAgreement.PrivateKey, publicKey: P256.KeyAgreement.PublicKey) throws -> SymmetricKey? {

        let sharedSecret = try? privateKey.sharedSecretFromKeyAgreement(with: publicKey)

        let symmetricKey = sharedSecret?.hkdfDerivedSymmetricKey(
            using: SHA256.self,
            salt: "My Key Agreement Salt".data(using: .utf8)!,
            sharedInfo: Data(),
            outputByteCount: 32)

        return symmetricKey
    }


    // encrtpt using the symmetric key and the text we eant to encrypt
    func encrypt(text: String, symmetricKey: SymmetricKey) throws -> String? {
        let textData = text.data(using: .utf8)!
        let encrypted = try? AES.GCM.seal(textData, using: symmetricKey)
        return encrypted?.combined?.base64EncodedString()
    }

    // decrypt the text we want using our symmetric key
    func decrypt(text: String, symmetricKey: SymmetricKey) -> String {

        guard let data = Data(base64Encoded: text) else {
            return "Could not decode text: \(text)"
        }

        let sealedBox = try? AES.GCM.SealedBox(combined: data)
        guard let sealed = sealedBox else {
            return "Could not get sealed box"
        }

        let decryptedData = try? AES.GCM.open(sealed, using: symmetricKey)

        guard let decryptedData = decryptedData else {
            return "could not decrypt the data"
        }

        guard let text = String(data: decryptedData, encoding: .utf8) else {
            return "Could not decode data: \(decryptedData)"
        }

        return text
    }
}
