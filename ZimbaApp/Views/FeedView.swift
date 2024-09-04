//
//  FeedView.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 4.09.2024.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = NewItemViewModel()
    @EnvironmentObject var authViewModel : AuthViewModel
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(viewModel.posts.isEmpty ? .gray : .gray).opacity(0.1).ignoresSafeArea()
                ScrollView{
                        VStack(alignment: .center, spacing: 20){
                            if viewModel.posts.isEmpty {
                                if !authViewModel.fullName.isEmpty{
                                    Text("Hoşgeldin, \(authViewModel.fullName)!")
                                        .font(.headline)
                                        .bold()
                                        .padding(.top, 300)
                                } else {
                                    Text("Yükleniyor...")
                                        .font(.headline)
                                        .bold()
                                        .padding(.top, 300)
                                }
                               
                            }
                            
                            ForEach(viewModel.posts, id: \.id) { post in
                                VStack(alignment: .leading, spacing: 10){
                                    Text(post.fullName)
                                        .font(.headline)
                                    Text(post.title)
                                        .font(.subheadline)
                                    
                                    if let url = URL(string: post.imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    
                                    if post.userId == authViewModel.currentUser?.id {
                                        Button(action: {
                                            viewModel.deletePost(postId: post.id)
                                        }, label: {
                                            Text("Delete")
                                                .foregroundColor(.red)
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(Color.gray.opacity(0.05))
                                                .cornerRadius(10)
                                        })
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                        }
                        .padding()
                    }
                    .onAppear{
                        viewModel.fetchPosts()
                    }
                }
            }
        }
    }

