//
//  ContentView.swift
//  Shared
//
//  Created by yeastar on 2023/3/30.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sdkData = YLSSDKData.shared
    var body: some View {
        if sdkData.isLogin {
            MenuView(isLogin: $sdkData.isLogin)
                .frame(minWidth: 500, minHeight: 340)
        } else {
            LoginView(isLogin: $sdkData.isLogin)
        }
    }
}
