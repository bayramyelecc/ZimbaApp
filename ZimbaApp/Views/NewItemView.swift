//
//  NewItemView.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 5.09.2024.
//

import SwiftUI

struct NewItemView: View {
    
    @State var baslik: String = ""
    @State var selectedPhoto: UIImage? = nil
    @State var showingImagePicker = false
    @StateObject var viewModel = NewItemViewModel()
    @Binding var selectedTab: Int
    
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.gray.opacity(0.1).ignoresSafeArea()
                VStack {
                    if let photo = selectedPhoto {
                        Image(uiImage: photo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .onTapGesture {
                                showingImagePicker = true
                            }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray.opacity(0.6))
                            .padding()
                            .onTapGesture {
                                showingImagePicker = true
                            }
                            .padding(50)
                    }
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $baslik)
                            .padding(4)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .border(Color.gray, width: 1)
                            .frame(height: 150)
                            .padding(.horizontal)
                        
                        if baslik.isEmpty {
                            Text("Bir şeyler yaz..")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 13)
                        }
                    }
                    
                    Button("Share") {
                        if let photo = selectedPhoto, !baslik.isEmpty, let user = authViewModel.currentUser {
                            viewModel.uploadPost(
                                title: baslik,
                                image: photo,
                                userId: user.id,
                                fullName: user.fullName ?? ""
                            )
                            selectedPhoto = nil
                            baslik = ""
                            selectedTab = 1
                        }
                    }
                    .padding().frame(maxWidth: .infinity).background(.gray.opacity(0.5)).cornerRadius(10).padding(.horizontal).foregroundColor(.white)
                    
                    Spacer()
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $selectedPhoto)
                }
                
            }
            .navigationTitle("Yeni Paylaşım")
            }
        }
    }
    

