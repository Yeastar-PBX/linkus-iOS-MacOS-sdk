//
//  ContentView.swift
//  Shared
//
//  Created by yeastar on 2023/3/30.
//

import SwiftUI

struct ContentView: View {
    @State var isLogin = UserDefaults.standard.bool(forKey: "isLogin")
    var body: some View {
//        if isLogin {
//            SidebarView()
//                .frame(minWidth: 500, minHeight: 340)
//        } else {
            LoginView(isLogin: $isLogin)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
