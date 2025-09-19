// AccessoryViews.swift
import SwiftUI

// MARK: - AccessorySquare
struct AccessorySquare: View {
    let accessory: Accessory
    @ObservedObject var profile: UserProfileViewModel
    let onBuy: () -> Void
    
    let size: CGFloat

    @State private var showingSheet = false

    var body: some View {
        VStack(spacing: 3) {
            Image(accessory.iconView)
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("AppRed"))
            
            
            if !profile.profile.inventory.contains(accessory.name) {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .imageScale(.small)
                        .foregroundColor(Color("AppRed"))
                    Text("\(accessory.price)")
                        .font(.system(size: 13, design: .monospaced).weight(.semibold))
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(.thinMaterial, in: Capsule())
                .padding(.bottom, 7)
            }
        }
        .frame(width: size, height: 140)
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

    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image(accessory.iconView)
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
                if !isOwned {
                    Button {
//                        onBuy()
//                        onDismiss()
                        showAlert.toggle()
                    } label: {
                        Text("Купить за \(Image(systemName: "star.fill")) \(accessory.price)")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .frame(minWidth: 300, minHeight: 55)
                            .background(canAfford ? Color("AppRed") : .gray)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .alert("",
                           isPresented: $showAlert,
                           actions: {
                               Button("Купить", role: .destructive) {
                                   onBuy()
                                   onDismiss()
                               }
                               Button("Отмена", role: .cancel) { }
                           },
                           message: {
                               Text("Вы уверены что хотите купить за \(accessory.price) очков?")
                           }
                    )
                    .disabled(!canAfford)
                }
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



// MARK: - InventoryAccessorySquare
struct InventoryAccessorySquare: View {
    let accessory: Accessory
    let isEquipped: Bool
    let size: CGFloat
    @EnvironmentObject var profile: UserProfileViewModel

    @State private var showingSheet = false

    var body: some View {
        VStack {
            Image(accessory.iconView)
                .font(.system(size: 40))
                .foregroundColor(Color("AppRed"))
        }
        .frame(width: size, height: size)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("SectionBackground"))
        )
//        .opacity(isEquipped ? 0.5 : 1.0) // Прозрачность для надетых аксессуаров
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
                Image(accessory.iconView)
                    .resizable()
                    .frame(width: 150, height: 150)
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
                        .font(.system(size: 16))
                        .fontWeight(.medium)
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
