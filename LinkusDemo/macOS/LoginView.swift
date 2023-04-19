//
//  LoginView.swift
//  Linkus
//
//  Created by 杨桂福 on 2022/9/14.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLogin: Bool
    enum Field: Hashable { case name, password, domain, localAddress, localPort }
    
    @State private var name = "1003"
    @State private var password = "Yeastar123"
    @State private var domain = "pbx.ras.yeastar.com"
    @State private var localAddress = "192.168.4.100"
    @State private var localPort = "8111"

    @FocusState private var isFocused: Field?
    
    var invalidInput: Bool {
        name.isEmpty || password.isEmpty || domain.isEmpty || localAddress.isEmpty || localPort.isEmpty
    }
    
    var body: some View {
        Spacer()
        Form {
            TextField(text: $name, prompt: Text("Required")) {
                Text("Username")
            }
            .focused($isFocused, equals: .name)
            
            TextField(text: $password, prompt: Text("Required")) {
                Text("password")
            }
            .focused($isFocused, equals: .password)
            
            TextField(text: $domain, prompt: Text("Required")) {
                Text("$domain")
            }
            .focused($isFocused, equals: .domain)
            
            TextField(text: $localAddress, prompt: Text("Required")) {
                Text("localAddress")
            }
            .focused($isFocused, equals: .localAddress)
            
            TextField(text: $localPort, prompt: Text("Required")) {
                Text("localPort")
            }
            .focused($isFocused, equals: .localPort)
            
            Button("登录") {
                if name.isEmpty {
                    isFocused = .name
                } else if password.isEmpty {
                    isFocused = .password
                } else if domain.isEmpty {
                    isFocused = .domain
                } else {
                    isFocused = nil
                    YLSSDK.shared().loginManager.login(name, token: password, pbxAddress: localAddress) { _ in 
                        
                    }
                    
                    print("用户输入的没有问题,可以提交至服务器")
                    UserDefaults.standard.set(true,forKey:"isLogin")
                    isLogin = true
                }
            }
            .disabled(invalidInput)
        }
        Spacer()
    }
}
