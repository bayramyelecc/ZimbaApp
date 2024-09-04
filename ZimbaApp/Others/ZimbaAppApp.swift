//
//  ZimbaAppApp.swift
//  ZimbaApp
//
//  Created by Bayram Yeleç on 4.09.2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ZimbaAppApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init(){
        let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = UIColor.gray.withAlphaComponent(0.05) // Navigasyon bar arka plan rengi
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.backgroundColor = UIColor.gray.withAlphaComponent(0.05) // Tab bar arka plan rengi
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
                    .background(Color.gray.opacity(0.1)).ignoresSafeArea()
                    .environmentObject(authViewModel)
            }
        }
    }
}
