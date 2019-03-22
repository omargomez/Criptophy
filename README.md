# Criptophy
by [@omargomez](https://twitter.com/omargomez)

## What's about

_Criptophy_ makes easy to work with the AES symetric encryption algorithms from Apple's _CCommonCrypto_ library. 

AES encryption is useful as way to persist App data locally (UserDefaults, SQLite) in a secure way. When working with AES, you usually follow this steps:

1. Retrieve or generate a key
2. Encrypt/decrypt data with this key
3. Find a secure scheme to store the key

_Criptophy_ takes care of steps 1) and 2). You only need to call `encrypt(data)` or `decrypt(data)`. Note that this framework is intended to deal with encrypted data wich is generated/stored locally into its own App, to share encrypted data you can take look at an RSA based solution, like _SwiftyRSA_.

## How to install

_Criptophy_ uses the [Carthage](https://github.com/Carthage/Carthage) package system. Once installed just add the following entry to your project's Cartfile:

```
github "omargomez/Criptophy"
```

## How to use it

```swift
        import Criptophy

        let input = "Hallo welt!"
        let secret = Cipher.shared.encrypt(input.data(using: .utf8)!)!
        let data = Cipher.shared.decrypt(secret)!
        let output = String(data: data, encoding: .utf8)!
        print("Input: \(input) , Output: \(output)")
```

That's all there is to it!

## How it works

The first time the _Cipher_ class is used, it random-generates a key, which is stored on the Keychain. This key then 
is used every time a encrypt/decrypt operation is called. 

## Alternatives

* A collection of standard and secure cryptographic algorithms implemented in Swift [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift)
* A simple Swift wrapper for Keychain [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)
* Public key RSA encryption in Swift [SwiftyRSA](https://github.com/TakeScoop/SwiftyRSA)

## Credits

The chipher code comes from my original inspiration for this Framework, the "[iOS Security: How to work with AES256 encrypt mechanism](https://medium.com/@vialyx/security-data-transforms-with-swift-aes256-on-ios-6509917497d)" blog post from [@Umaks_vs](https://twitter.com/Umaks_vs)