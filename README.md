# BLSCT

[![Platform](https://img.shields.io/badge/Platforms-macOS%20%7C%20iOS-blue)](#platforms)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-orange)](#swift-package-manager)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/anquii/BLSCT/blob/main/LICENSE)

An implementation of [BLSCT](https://docs.navcoin.org/blsct) in Swift. BLSCT is a privacy protocol developed by [Navcoin](https://github.com/navcoin), which merges Boneh-Lynn-Shacham (BLS) Signatures and Confidential Transactions (CT). BLSCT transactions are currently not supported, but will be added in a future release.

## Platforms
- macOS 11+
- iOS 14+

## Installation

### Swift Package Manager

Add the following line to your `Package.swift` file:
```swift
.package(url: "https://github.com/anquii/BLSCT.git", from: "1.0.0")
```
...or integrate with Xcode via `File -> Swift Packages -> Add Package Dependency...` using the URL of the repository.

## Usage

```swift
import BLSCT

// Private BLS keys
let mclPreparator: MCLPreparing = MCLPreparator()
let privateBLSKeyDerivator: PrivateBLSKeyDerivating = PrivateBLSKeyDerivator()
let privateBLSMasterKeyDerivator: PrivateBLSMasterKeyDerivating = PrivateBLSMasterKeyDerivator(privateBLSKeyDerivator: privateBLSKeyDerivator)
let privateBLSChildKeyDerivator: PrivateBLSChildKeyDerivating = try PrivateBLSChildKeyDerivator(privateBLSKeyDerivator: privateBLSKeyDerivator, mclPreparator: mclPreparator)
let privateBLSKeysDerivator: PrivateBLSKeysDerivating = PrivateBLSKeysDerivator(privateBLSMasterKeyDerivator: privateBLSMasterKeyDerivator, privateBLSChildKeyDerivator: privateBLSChildKeyDerivator)
let privateBLSKeys = try privateBLSKeysDerivator.privateKeys(base58CheckEncodedPrivateMasterKey: "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi") // (privateBLSViewKey, privateBLSSpendKey, privateBLSBlindingKey)

// Public BLS keys
let publicBLSKeysDerivator: PublicBLSKeysDerivating = try PublicBLSKeysDerivator(privateBLSViewKey: privateBLSKeys.privateBLSViewKey, privateBLSSpendKey: privateBLSKeys.privateBLSSpendKey, mclPreparator: mclPreparator)
let publicBLSKeys = try publicBLSKeysDerivator.publicKeys(accountIndex: 0, subAddressIndex: 0) // (publicBLSViewKey, publicBLSSpendKey)

// Address
let addressCoder: AddressCoding = AddressCoder()
let address = addressCoder.address(publicBLSViewKey: publicBLSKeys.publicBLSViewKey, publicBLSSpendKey: publicBLSKeys.publicBLSSpendKey)
// e.g. xNVM1yykP9cSc737VCMzP8kWR77gPn1iujPitHRm6urfrVRDLbNinxsRTZb3CCsYCD3Uqj3RCQubEYaHj3XKmGMbFTDctT2JVJ6CCazXomPmoiPGB3qf8rfKp7NEyzKupjeSD4CfkKS
```

Find out more by exploring the public API, and by looking through the [tests](Tests/BLSCTTests). If you're creating a wallet, make sure to store the `publicBLSSpendKey` alongside the integer pair `(accountIndex, subAddressIndex)` used as part of its derivation (as documented [here](https://docs.navcoin.org/blsct)).

## License

`BLSCT` is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for more information.
