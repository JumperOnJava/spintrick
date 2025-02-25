//
//  spintrickApp.swift
//  spintrick
//
//  Created by Slywa on 14.02.2025.
//

import SwiftUI

@main
struct spintrickApp: App {
    init(){
        SpinService().spinServiceInit()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
