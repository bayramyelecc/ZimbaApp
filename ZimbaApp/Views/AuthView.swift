//
//  AuthView.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 4.09.2024.
//

import SwiftUI

struct AuthView: View {
    
    @State var pickerSelect = false
    @State var fullName = ""
    @State var email = ""
    @State var password = ""
    @State var selectedPhoto : UIImage? = nil
    @State var showingImagePicker = false
    
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                    VStack{
                        
                        Picker(selection: $pickerSelect,
                               label: Text("")){
                            Text("Giriş Yap").tag(false)
                            Text("Kayıt Ol").tag(true)
                            
                        }.pickerStyle(SegmentedPickerStyle()).padding()
                        
                        if pickerSelect {
                            
                            if let photo = selectedPhoto {
                                Image(uiImage: photo)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                            
                            Button("Fotoğraf Seç") {
                                showingImagePicker = true
                            }
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .frame(width: 200, height: 100, alignment: .center)
                            .padding(.horizontal)
                            
                            TextField(text: $fullName) {
                                Text("Full Name..")
                                    .foregroundStyle(.white)
                            }.padding().background(.gray.opacity(0.2)).cornerRadius(10).autocapitalization(.none).padding(.horizontal)
                            
                            TextField(text: $email) {
                                Text("E-mail..")
                                    .foregroundStyle(.white)
                            }.padding().background(.gray.opacity(0.2)).cornerRadius(10).autocapitalization(.none).padding(.horizontal)
                            SecureField(text: $password) {
                                Text("Password..")
                                    .foregroundStyle(.white)
                            }.padding().background(.gray.opacity(0.2)).cornerRadius(10).autocapitalization(.none).padding(.horizontal)
                            Button(action: {
                                authViewModel.signUp(email: email, password: password, fullName: fullName, photo: selectedPhoto)
                            }, label: {
                                Text("Kayıt Ol")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.gray.opacity(0.8))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            })
                            .sheet(isPresented: $showingImagePicker){
                                ImagePicker(image: $selectedPhoto)
                            }
                        }
                        else {
                            
                            Text("ZIMBA")
                                .font(.system(size: 50))
                                .font(.largeTitle).bold()
                                .frame(width: 200, height: 100, alignment: .center)
                                .padding()
                                .foregroundColor(.gray)
                            
                            TextField(text: $email) {
                                Text("E-mail..")
                                    .foregroundStyle(.white)
                            }.padding().background(.gray.opacity(0.2)).cornerRadius(10).autocapitalization(.none).padding(.horizontal)
                            SecureField(text: $password) {
                                Text("Password..")
                                    .foregroundStyle(.white)
                            }.padding().background(.gray.opacity(0.2)).cornerRadius(10).autocapitalization(.none).padding(.horizontal)
                            Button(action: {
                                authViewModel.signIn(email: email, password: password)
                            }, label: {
                                Text("Giriş Yap")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.gray.opacity(0.8))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            })
                        }
                        Spacer()
                    }
            }
            .navigationTitle(!pickerSelect ? "Giriş Sayfası" : "Kayıt Sayfası")
        }
    }
}

#Preview {
    AuthView()
}
