//
//  FriendsView.swift
//  Novator
//
//  Created by j on 08.09.2025.
//

import SwiftUI

struct FriendsView: View {
    
    @State var showSheetFriends = false
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    
                    
                    
                    
                    ForEach(1...10, id: \.self) {_ in
                        
                        FriendRow(name: "Павел Дуров", level: "11")
                        
                    }
                }
                .padding(.top, 40)
            }
            .navigationTitle("Друзья")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSheetFriends.toggle()
                    } label: {
                        Image(systemName: "person.2.square.stack.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color("AppRed"))
                    }
                }
            }
            .sheet(isPresented: $showSheetFriends) {
                Text("тут заявки") // это не трогай
            }
        }
    }
}


struct FriendRow: View {
    
    let name: String
    let level: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .font(.system(size: 35))
                .foregroundColor(Color("AppRed"))
                .padding(.leading, 10)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 15))
                Text("Уровень \(level)")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Divider()
            }
        }
    }
    
}


#Preview {
    FriendsView()
}
