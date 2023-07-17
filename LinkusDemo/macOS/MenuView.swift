//
//  MenuView.swift
//  LinkusDemo (macOS)
//
//  Created by 杨桂福 on 2023/4/23.
//

import SwiftUI
import AVFoundation

enum Panel: Hashable {
    case callLogs
    case call
    case devices
}

struct MenuView: View {
    @Binding var isLogin: Bool
    @State private var number = "1011"
    @ObservedObject var historyData = HistoryData.shared
    @State private var selection: Panel? = Panel.callLogs
    var body: some View {
        NavigationView {
            List(selection: $selection) {
                NavigationLink(tag: Panel.callLogs, selection: $selection) {
                    List {
                        ForEach(HistoryData.mergeData(historys: historyData.historys),id: \.self) { mergeHistory in
                            HStack(alignment: .center, spacing: 16) {
                                Text(mergeHistory.number.prefix(1))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 36, height: 36)
                                    .background(.blue)
                                    .clipShape(Circle())
                                Text("\(mergeHistory.number) (\(mergeHistory.theSameHistory.count))")
                                    .foregroundColor(mergeHistory.state == .missed ? .red : .black)
                                Spacer()
                                Text("\(NSString.timeCompare(mergeHistory.theSameHistory.first?.timeGMT))")
                            }
                        }
                    }
                } label: {
                    Text("通话记录")
                }
                NavigationLink(tag: Panel.call, selection: $selection) {
                    VStack(alignment: .center, spacing: 16) {
                        Button("申请麦克风权限") {
                            AVCaptureDevice.requestAccess(for: AVMediaType.audio) { granted in
                                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
                                if granted {
                                    print("同意麦克风权限")
                                } else {
                                    if status == AVAuthorizationStatus.denied {
                                        print("不同意麦克风权限")
                                    } else if status == AVAuthorizationStatus.notDetermined {
                                        print("未授权麦克风权限")
                                    } else if status == AVAuthorizationStatus.restricted {
                                        print("AVAuthorizationStatusRestricted")
                                    }
                                }
                            }
                        }
                        HStack(alignment: .bottom, spacing: 16) {
                            Button("呼叫") {
                                let sipCall = YLSSipCall()
                                sipCall.callNumber = number
                                YLSCallTool.share().start(sipCall) {_ in
                                    YLSSDKData.shared.popCallView()
                                }
                            }
                            TextField(text: $number, prompt: Text("Required")) {
                                Text("拨打的号码")
                            }.frame(width: 80)
                        }
                        Button("退出登录") {
                            YLSSDK.shared().loginManager.logout { _ in
                                isLogin = false
                            }
                        }
                    }
                } label: {
                    Text("拨打电话")
                }
                NavigationLink(tag: Panel.devices, selection: $selection) {
                    List {
                        Section(header: Text("麦克风")) {
                            ForEach(YLSSDK.shared().callManager.audioALLDevice().filter{$0.type == .microphone},id: \.self) { device in
                                HStack(alignment: .bottom, spacing: 16) {
                                    Text("\(device.deviceName)")
                                    Button("设置") {
                                        YLSSDKData.shared.changeMicrophone(newMicrophone: Int(device.devid))
                                    }
                                }
                            }
                        }
                        Section(header: Text("扬声器")) {
                            ForEach(YLSSDK.shared().callManager.audioALLDevice().filter{$0.type == .speaker},id: \.self) { device in
                                HStack(alignment: .bottom, spacing: 16) {
                                    Text("\(device.deviceName)")
                                    Button("设置") {
                                        YLSSDKData.shared.changeSpeaker(newSpeaker: Int(device.devid))
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Text("输出设备")
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 160)
        }
    }
}
