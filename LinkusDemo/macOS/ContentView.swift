//
//  ContentView.swift
//  Shared
//
//  Created by yeastar on 2023/3/30.
//

import SwiftUI

struct ContentView: View {
    var modelData = YLSSDKData.shared
    @State var isLogin = false
    var body: some View {
        if isLogin {
            MenuView(isLogin: $isLogin)
                .frame(minWidth: 500, minHeight: 340)
        } else {
            LoginView(isLogin: $isLogin)
        }
    }
}
