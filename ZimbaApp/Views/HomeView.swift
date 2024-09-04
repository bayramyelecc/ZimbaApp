//
//  HomeView.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 4.09.2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authViewModel : AuthViewModel
    @State var selectedTab : Int = 1
    
    
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.1).ignoresSafeArea()
            NavigationStack{
                VStack{
                    TabView(selection: $selectedTab){
                        FeedView()
                            .tabItem {
                                Image(systemName: "house.fill")
                            }.tag(1)
                        NewItemView(selectedTab: $selectedTab)
                            .tabItem {
                                Image(systemName: "plus.app")
                            }.tag(2)
                        ProfileView()
                            .tabItem {
                                Image(systemName: "person.fill")
                            }.tag(3)
                    }
                    
                    .accentColor(.black)
                }
                .navigationTitle("ZIMBA")
                
                .navigationBarBackButtonHidden()
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

