// AccessoryViews.swift
import SwiftUI

// MARK: - AccessorySquare
struct AccessorySquare: View {
    let accessory: Accessory
    @ObservedObject var profile: UserProfileViewModel
    let onBuy: () -> Void

    @State private var showingSheet = false

    var body: some View {
        VStack {
            ZStack {
                Image(systemName: accessory.icon)
                    .font(.system(size: 40))
                    .foregroundColor(Color("AppRed"))
                if profile.profile.inventory.contains(accessory.name) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                        .offset(x: 15, y: -15)
                } else if profile.profile.stars < accessory.price {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .offset(x: 15, y: -15)
                }
            }
            Text(accessory.name)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            if !profile.profile.inventory.contains(accessory.name) {
                Text("\(accessory.price) ⭐")
                    .font(.caption2)
                    .foregroundColor(profile.profile.stars >= accessory.price ? .primary : .red)
            }
        }
        .frame(width: 80, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("SectionBackground"))
        )
        .onTapGesture {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            AccessoryDetailSheet(
                accessory: accessory,
                isOwned: profile.profile.inventory.contains(accessory.name),
                canAfford: profile.profile.stars >= accessory.price,
                onBuy: onBuy,
                onDismiss: { showingSheet.toggle() }
            )
        }
    }
}

// MARK: - AccessoryDetailSheet (Новый sheet для покупки)
struct AccessoryDetailSheet: View {
    let accessory: Accessory
    let isOwned: Bool
    let canAfford: Bool
    let onBuy: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: accessory.icon)
                    .font(.system(size: 100))
                    .foregroundColor(Color("AppRed"))
                Text(accessory.name)
                    .font(.title)
                if let description = accessory.description {
                    Text(description)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                Text("Цена: \(accessory.price) ⭐")
                    .font(.subheadline)
                    .foregroundColor(canAfford ? .primary : .red)
                Spacer()
                if !isOwned {
                    Button("Купить") {
                        onBuy()
                        onDismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(canAfford ? Color("AppRed") : .gray)
                    .frame(minWidth: 200, minHeight: 50)
                    .disabled(!canAfford)
                }
                Button("Отмена") {
                    onDismiss()
                }
                .frame(minWidth: 200, minHeight: 50)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(20)
    }
}

// MARK: - AccessoryDetailView
struct AccessoryDetailView: View {
    let accessory: Accessory
    let isOwned: Bool
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: accessory.icon)
                    .font(.system(size: 150))
                    .foregroundColor(Color("AppRed"))
                Text(accessory.name)
                    .font(.title)
                if let description = accessory.description {
                    Text(description)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(action: onDismiss) {
                    Text("ОК")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(minWidth: 300, minHeight: 55)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .presentationDetents([.height(500)])
        .presentationCornerRadius(20)
    }
}

// MARK: - InventoryAccessorySquare
struct InventoryAccessorySquare: View {
    let accessory: Accessory
    let isEquipped: Bool
    let size: CGFloat
    @EnvironmentObject var profile: UserProfileViewModel

    @State private var showingSheet = false

    var body: some View {
        VStack {
            Image(systemName: accessory.icon)
                .font(.system(size: 40))
                .foregroundColor(Color("AppRed"))
        }
        .frame(width: size, height: size)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("SectionBackground"))
        )
        .onTapGesture { showingSheet.toggle() }
        .sheet(isPresented: $showingSheet) {
            InventoryAccessorySheet(
                accessory: accessory,
                isEquipped: isEquipped,
                onApply: { profile.applyAccessory(accessory) },
                onRemove: { profile.removeAccessory(accessory) },
                onDismiss: { showingSheet.toggle() }
            )
        }
    }
}

// MARK: - InventoryAccessorySheet
struct InventoryAccessorySheet: View {
    let accessory: Accessory
    let isEquipped: Bool
    let onApply: () -> Void
    let onRemove: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: accessory.icon)
                    .font(.system(size: 150))
                    .foregroundColor(Color("AppRed"))
                Text(accessory.name)
                    .font(.title)
                if let description = accessory.description {
                    Text(description)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                Spacer()
                Button {
                    if isEquipped {
                        onRemove()
                        onDismiss()
                    } else {
                        onApply()
                        onDismiss()
                    }
                } label: {
                    Text(isEquipped ? "Снять" : "Применить")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(minWidth: 300, minHeight: 55)
                }
                .buttonStyle(PrimaryButtonStyle())
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .presentationDetents([.height(500)])
        .presentationCornerRadius(20)
    }
}
