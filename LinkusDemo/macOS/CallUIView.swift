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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("当前通话的号码：\(sdkData.sipCall.callNumber)")
            if sdkData.sipCall.status == .bridge {
                HStack(alignment: .bottom, spacing: 16) {
                    Button("Hold") {
                        isHoldSelected.toggle()
                        let sipCall = sdkData.sipCall
                        if sipCall.mute {
                            sipCall.mute = false
                            isMuteSelected = false
                            YSLCallTool.share().setMute(sipCall)
                        }
                        sipCall.onHold = isHoldSelected;
                        YSLCallTool.share().setHeld(sipCall)
                    }
                    .background(isHoldSelected ? Color.blue : Color.white)
                    Button("Mute") {
                        isMuteSelected.toggle()
                        let sipCall = sdkData.sipCall
                        sipCall.mute = isMuteSelected;
                        YSLCallTool.share().setMute(sipCall)
                    }
                    .background(isMuteSelected ? Color.blue : Color.white)
                    Button("挂断") {
                        let sipCall = sdkData.sipCall
                        sipCall.hangUpType = HangUpType.byHand
                        YSLCallTool.share().end(sipCall)
                    }
                }
                HStack(alignment: .bottom, spacing: 16) {
                    Button("Dialpad") {
                        YSLCallTool.share().setDTMF(sdkData.sipCall, string: dtmfText)
                    }
                    .disabled(dtmfText.isEmpty)
                    TextField(text: $dtmfText, prompt: Text("DTMF")) { }
                    .frame(width: 100)
                    .onChange(of: dtmfText) { newValue in
                        dtmfText = String(newValue.suffix(1))
                        print("\(dtmfText)")
                    }
                }
                HStack(alignment: .bottom, spacing: 16) {
                    Button("Attended") {
                        let sipCall = YLSSipCall()
                        sipCall.callNumber = attendNumber
                        YSLCallTool.share().start(sipCall) {_ in
                            sureAttend = true
                        }
                    }
                    .disabled(attendNumber.isEmpty)
                    TextField(text: $attendNumber, prompt: Text("Attended Number")) { }
                    .frame(width: 100)
                    if sureAttend {
                        Button("确认转移") {
                            YSLCallTool.share().transferConsultation()
                        }
                    }
                }
                HStack(alignment: .bottom, spacing: 16) {
                    Button("Blind") {
                        let sipCall = YLSSipCall()
                        sipCall.callNumber = blindNumber
                        YSLCallTool.share().tranforBlind(sipCall)
                    }
                    .disabled(blindNumber.isEmpty)
                    TextField(text: $blindNumber, prompt: Text("Blind Number")) { }
                    .frame(width: 100)
                }
            } else {
                if sdkData.sipCall.callIn {
                    HStack(alignment: .bottom, spacing: 16) {
                        Button("接听") {
                            YSLCallTool.share().answer(sdkData.sipCall)
                        }
                        Button("挂断") {
                            let sipCall = sdkData.sipCall
                            sipCall.hangUpType = HangUpType.byHand
                            YSLCallTool.share().end(sipCall)
                        }
                    }
                } else {
                    HStack(alignment: .bottom, spacing: 16) {
                        if sureAttend {
                            Button("确认转移") {
                                YSLCallTool.share().transferConsultation()
                            }
                        }
                        Button("挂断") {
                            let sipCall = sdkData.sipCall
                            sipCall.hangUpType = HangUpType.byHand
                            YSLCallTool.share().end(sipCall)
                        }
                    }
                }
            }
        }
    }
}

