//
//  CallUIView.swift
//  LinkusDemo (macOS)
//
//  Created by 杨桂福 on 2023/4/25.
//

import SwiftUI

struct CallUIView: View {
    @ObservedObject var sdkData = YLSSDKData.shared
    @State private var isHoldSelected = false
    @State private var isMuteSelected = false
    @State private var dtmfText  = ""
    @State private var attendNumber = ""
    @State private var blindNumber = ""
    @State private var sureAttend = false
    @State var callQuality = ""
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("当前通话的号码：\(sdkData.sipCall.callNumber)")
            if sdkData.sipCall.status == .bridge {
                HStack(alignment: .center, spacing: 32) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .bottom, spacing: 16) {
                            Button("Hold") {
                                isHoldSelected.toggle()
                                let sipCall = sdkData.sipCall
                                if sipCall.mute {
                                    sipCall.mute = false
                                    isMuteSelected = false
                                    YLSCallTool.share().setMute(sipCall)
                                }
                                sipCall.onHold = isHoldSelected;
                                YLSCallTool.share().setHeld(sipCall)
                            }
                            .background(isHoldSelected ? Color.blue : Color.white)
                            Button("Mute") {
                                isMuteSelected.toggle()
                                let sipCall = sdkData.sipCall
                                sipCall.mute = isMuteSelected;
                                YLSCallTool.share().setMute(sipCall)
                            }
                            .background(isMuteSelected ? Color.blue : Color.white)
                            Button("挂断") {
                                let sipCall = sdkData.sipCall
                                sipCall.hangUpType = HangUpType.byHand
                                YLSCallTool.share().end(sipCall)
                            }
                        }
                        HStack(alignment: .bottom, spacing: 16) {
                            Button("Dialpad") {
                                for char in dtmfText {
                                    YLSCallTool.share().setDTMF(sdkData.sipCall, string: String(char))
                                    print(String(char))
                                }
                            }
                            .disabled(dtmfText.isEmpty)
                            TextField(text: $dtmfText, prompt: Text("DTMF")) { }
                            .frame(width: 100)
                        }
                        HStack(alignment: .bottom, spacing: 16) {
                            Button("Attended") {
                                let sipCall = YLSSipCall()
                                sipCall.callNumber = attendNumber
                                YLSCallTool.share().start(sipCall) {_ in
                                    sureAttend = true
                                }
                            }
                            .disabled(attendNumber.isEmpty)
                            TextField(text: $attendNumber, prompt: Text("Attended Number")) { }
                            .frame(width: 100)
                            if sureAttend {
                                Button("确认转移") {
                                    YLSCallTool.share().transferConsultation()
                                }
                            }
                        }
                        HStack(alignment: .bottom, spacing: 16) {
                            Button("Blind") {
                                let sipCall = YLSSipCall()
                                sipCall.callNumber = blindNumber
                                YLSCallTool.share().tranforBlind(sipCall)
                            }
                            .disabled(blindNumber.isEmpty)
                            TextField(text: $blindNumber, prompt: Text("Blind Number")) { }
                            .frame(width: 100)
                        }
                        Button("录音") {
                            YLSCallTool.share().setRecord(YLSSDK.shared().callManager.currentSipCall())
                        }
                    }
                    Text(callQuality)
                }
                .onReceive(timer) { input in
                    callQuality = YLSCallTool.share().callQuality()
                }
            } else {
                if sdkData.sipCall.callIn {
                    HStack(alignment: .bottom, spacing: 16) {
                        Button("接听") {
                            YLSCallTool.share().answer(sdkData.sipCall)
                        }
                        Button("挂断") {
                            let sipCall = sdkData.sipCall
                            sipCall.hangUpType = HangUpType.byHand
                            YLSCallTool.share().end(sipCall)
                        }
                    }
                } else {
                    HStack(alignment: .bottom, spacing: 16) {
                        if sureAttend {
                            Button("确认转移") {
                                YLSCallTool.share().transferConsultation()
                            }
                        }
                        Button("挂断") {
                            let sipCall = sdkData.sipCall
                            sipCall.hangUpType = HangUpType.byHand
                            YLSCallTool.share().end(sipCall)
                        }
                    }
                }
            }
        }
    }
}

