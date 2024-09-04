//
//  ContentView.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 4.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.isSignedIn {
            HomeView().environmentObject(authViewModel).background(Color.gray.opacity(0.1))
        } else {
            AuthView().environmentObject(authViewModel)
        }
    }
}

#Preview {
    ContentView()
}
