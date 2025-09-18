// AccessoryViewModel.swift
import Foundation
import SwiftUI
import Combine

class AccessoryViewModel: ObservableObject {
    @Published var profile: UserProfile
    
    init(profile: UserProfile) {
        self.profile = profile
    }
    
    // Buy an accessory: Check price, deduct stars, add to inventory
    func buyAccessory(_ accessory: Accessory) {
        guard !profile.inventory.contains(accessory.name),
              profile.stars >= accessory.price else {
            print("⚠️ Cannot buy: Insufficient stars (\(profile.stars) < \(accessory.price)) or already owned")
            return
        }
        
        profile.stars -= accessory.price
        profile.inventory.append(accessory.name)
        print("✅ Bought accessory: \(accessory.name), new stars: \(profile.stars), inventory: \(profile.inventory)")
    }
    
    // Apply accessory: Replace any existing equipped accessory (max 1)
    func applyAccessory(_ accessory: Accessory) {
        guard profile.inventory.contains(accessory.name),
              !profile.equippedAccessories.contains(accessory.name) else {
            print("⚠️ Cannot apply: Not owned or already equipped")
            return
        }
        
        // Replace any existing equipped accessory
        if !profile.equippedAccessories.isEmpty {
            let previousAccessoryName = profile.equippedAccessories.first!
            profile.equippedAccessories.removeAll { $0 == previousAccessoryName }
            print("✅ Removed previous accessory: \(previousAccessoryName)")
        }
        
        profile.equippedAccessories = [accessory.name]
        print("✅ Applied accessory: \(accessory.name), equipped: \(profile.equippedAccessories)")
    }
    
    // Remove equipped accessory
    func removeAccessory(_ accessory: Accessory) {
        guard let index = profile.equippedAccessories.firstIndex(of: accessory.name) else {
            print("⚠️ Cannot remove: Not equipped")
            return
        }
        
        profile.equippedAccessories.remove(at: index)
        print("✅ Removed accessory: \(accessory.name), equipped: \(profile.equippedAccessories)")
    }
}
