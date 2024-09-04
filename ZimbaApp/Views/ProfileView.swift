//
//  ProfileView.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 4.09.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                VStack{
                    if let user = authViewModel.currentUser{
                        if let photoUrl = user.photoUrl, let url = URL(string: photoUrl){
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }.padding().onTapGesture {
                                
                            }
                        }
                        Text("\(user.fullName ?? "")")
                            .font(.largeTitle).bold().padding()
                        Text("Kayıt olma tarihi : \(user.dateCreated, formatter: dateFormatter)").padding()
                        Button(action: {
                            authViewModel.signOut()
                        }, label: {
                            Text("Çıkış Yap")
                                .foregroundStyle(Color.white)
                                .padding()
                                .font(.title2).bold()
                                .frame(maxWidth: .infinity)
                                .background(.gray)
                                .cornerRadius(10)
                                .padding()
                        })
                    }
                }
                .navigationTitle("Profil")
            }
        }
    }
    private var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    ProfileView()
}
