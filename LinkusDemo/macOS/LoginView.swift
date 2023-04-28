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
    
    @State private var name = "1009"
    @State private var password = "Yeastar123"
    @State private var localAddress = "192.168.22.138"

    @FocusState private var isFocused: Field?
    
    var invalidInput: Bool {
        name.isEmpty || password.isEmpty || localAddress.isEmpty
    }
    
    var body: some View {
        Spacer()
        Form {
            TextField(text: $name, prompt: Text("Required")) {
                Text("Username")
            }
            .focused($isFocused, equals: .name)
            .frame(width: 200)
            
            TextField(text: $password, prompt: Text("Required")) {
                Text("password")
            }
            .focused($isFocused, equals: .password)
            .frame(width: 200)
                        
            TextField(text: $localAddress, prompt: Text("Required")) {
                Text("localAddress")
            }
            .focused($isFocused, equals: .localAddress)
            .frame(width: 200)
                        
            Button("登录") {
                if name.isEmpty {
                    isFocused = .name
                } else if password.isEmpty {
                    isFocused = .password
                } else {
                    isFocused = nil
                    print("用户输入的没有问题,可以提交至服务器")
                    YLSSDK.shared().loginManager.login(name, token: password, pbxAddress: localAddress) { err in
                        if err == nil {
                            isLogin = true
                        }
                    }
                }
            }
            .disabled(invalidInput)
        }
        Spacer()
    }
}
