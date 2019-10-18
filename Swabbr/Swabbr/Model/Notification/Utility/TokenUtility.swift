//
//  TokenUtility.swift
//  Swabbr
//
//  Created by James Bal on 15-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct TokenUtility {
    
    typealias Context = UnsafeMutablePointer<CCHmacContext>
    
    /**
     Prepares the generation of the token.
     1. Computing the expiry in UNIXEpoch time format
     2. Formatting the ResourceUrl to percent-encoding and lowercase. The form is as follow: https://\<namespace>.servicebus.windows.net/\<hubName>
     3. Preparing the string to sign. The form is as follow: \<UrlEncodedResourceUrl>\\n\<ExpiryEpoch>
     4. Base64-encoding of the signature using HMAC 256.
     5. Formatting Base64 encoding signature to percent encoded.
     6. Constructing the Token by being conform to the TokenData.
     - parameter resourceUrl: A string representing the url.
     - parameter keyName: A string representing the name of the key.
     - parameter key: A string representing the key.
     - parameter expiryInSeconds: An int value representing the validity time in seconds.
     - Returns: A TokenData object.
    */
    static func getSasToken(forResourceUrl resourceUrl : String, withKeyName keyName : String, andKey key : String, andExpiryInSeconds expiryInSeconds : Int = 3600) -> TokenData {
        let expiry = (Int(NSDate().timeIntervalSince1970) + expiryInSeconds).description
        let encodedUrl = urlEncodedString(withString: resourceUrl)
        let stringToSign = "\(encodedUrl)\n\(expiry)"
        let hashValue = sha256HMac(withData: stringToSign.data(using: .utf8)!, andKey: key.data(using: .utf8)!)
        let signature = hashValue.base64EncodedString(options: .init(rawValue: 0))
        let encodedSignature = urlEncodedString(withString: signature)
        let sasToken = "SharedAccessSignature sr=\(encodedUrl)&sig=\(encodedSignature)&se=\(expiry)&skn=\(keyName)"
        let tokenData = TokenData(withToken: sasToken, andTokenExpiration: expiryInSeconds)
        
        return tokenData
    }
    
    /**
     It computes the signature to a HMAC 256 format.
     - parameter data: A data value which represents the data of the string to sign.
     - parameter key: A data value which represents the data of the key.
     - Returns: Data of a base64 encoded string.
    */
    private static func sha256HMac(withData data : Data, andKey key : Data) -> Data {
        let context = Context.allocate(capacity: 1)
        CCHmacInit(context, CCHmacAlgorithm(kCCHmacAlgSHA256), (key as NSData).bytes, size_t((key as NSData).length))
        CCHmacUpdate(context, (data as NSData).bytes, (data as NSData).length)
        var hmac = Array<UInt8>(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmacFinal(context, &hmac)
        
        let result = NSData(bytes: hmac, length: hmac.count)
        context.deallocate()
        
        return result as Data
    }
    
    /**
     This function will encode the given string to a percent-encoding for an url.
     - parameter stringToConvert: A string value which represents the resource url.
     - Returns: A string which is percent-encoded.
    */
    private static func urlEncodedString(withString stringToConvert : String) -> String {
        var encodedString = ""
        let sourceUtf8 = (stringToConvert as NSString).utf8String
        let length = strlen(sourceUtf8)
        
        let charArray: [Character] = [ ".", "-", "_", "~", "a", "z", "A", "Z", "0", "9"]
        let asUInt8Array = String(charArray).utf8.map{ Int8($0) }
        
        for i in 0..<length {
            let currentChar = sourceUtf8![i]
            
            if (currentChar == asUInt8Array[0] || currentChar == asUInt8Array[1] || currentChar == asUInt8Array[2] || currentChar == asUInt8Array[3] ||
                (currentChar >= asUInt8Array[4] && currentChar <= asUInt8Array[5]) ||
                (currentChar >= asUInt8Array[6] && currentChar <= asUInt8Array[7]) ||
                (currentChar >= asUInt8Array[8] && currentChar <= asUInt8Array[9])) {
                encodedString += String(format:"%c", currentChar)
            }
            else {
                encodedString += String(format:"%%%02x", currentChar)
            }
        }
        
        return encodedString
    }
    
}
