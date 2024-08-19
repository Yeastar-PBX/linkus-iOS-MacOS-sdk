//
//  YLSSDKData.swift
//  LinkusDemo (macOS)
//
//  Created by 杨桂福 on 2023/4/23.
//

import Foundation
import AppKit
import SwiftUI
import Combine

final class YLSSDKData: NSObject, ObservableObject, MacCallProviderDelegate{
    public static let shared = YLSSDKData()
    
    lazy var window: NSWindow = {
        let window = NSWindow(contentRect: NSRect(x: 20, y: 20, width: 500, height: 340),
                       styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                       backing: .buffered,
                       defer: false)
        return window
    }()
    
    @Published var sipCall = YLSSipCall()
    @Published var isLogin = false
    var microphone = -1
    var speaker = -1
    
    private override init() {
        super.init()
        YLSSDKConfig.shared().hangupAudioFileName = "Hangup.wav"
        YLSSDKConfig.shared().alertAudioFileName = "Alerting.wav"
        YLSSDKConfig.shared().comeAudioFileName = "incoming.wav"
        YLSSDKConfig.shared().sipCode = UserDefaults().string(forKey: "sipCode") ?? ""
//        YLSSDKConfig.shared().dataPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
//        YLSSDKConfig.shared().logPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        YLSSDK.shared().initApp()
        MacCallProvider.share().delegate = self
    }
        
    func popCallView() {
        window.center()
        window.title = "通话界面"
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        window.contentView = NSHostingView(rootView: CallUIView().frame(minWidth: 500, minHeight: 340))
    }
    
    func dismissCallView() {
        window.close()
        window.orderOut(nil)
    }
    
    func loginOut() {
        isLogin = false
    }
    
    func reloadCurrentCall(_ sipCall :YLSSipCall) {
        self.sipCall = sipCall
    }
    
    func changeMicrophone(newMicrophone: Int) {
        self.microphone = newMicrophone
        YLSSDK.shared().callManager.audioSetDevice(newMicrophone, speaker: self.speaker)
    }
    
    func changeSpeaker(newSpeaker: Int) {
        self.speaker = newSpeaker
        YLSSDK.shared().callManager.audioSetDevice(self.microphone, speaker: newSpeaker)
    }
}

final class HistoryData: NSObject, ObservableObject, YLSHistoryManagerDelegate {
    public static let shared = HistoryData()
    @Published var historys = YLSSDK.shared().historyManager.historys()
    
    private override init() {
        super.init()
        YLSSDK.shared().historyManager.add(self)
    }
    
    func historyReload(_ historys: NSMutableArray) {
        self.historys = historys as! [YLSHistory]
    }
    
    func historyMissCallCount(_ count: NSInteger) {
        print("未读数量 \(count)")
    }
    
    class func mergeData(historys: [YLSHistory]) -> ([MergeHistory]) {
        var dealArray = [MergeHistory]()
        
        historys.reversed().forEach { history in
            let mergeHistory = dealArray.first
            let saveHistory = dealArray.first?.theSameHistory.first
            /**
             *  CDR合并规则
             *  1.同一联系人
               */
            let first = saveHistory?.number == history.number
            var second = false
            if ((saveHistory?.state == .callOut && history.state == .callOut) || (saveHistory?.state != .callOut && history.state != .callOut)) {
                second = true;
            }
            if first && second {
                var theSameHistory = mergeHistory!.theSameHistory
                theSameHistory.insert(history, at: 0)
                dealArray[0] = MergeHistory(number: history.number, state: history.state, theSameHistory: theSameHistory)
            } else {
                var theSameHistory = [YLSHistory]()
                theSameHistory.insert(history, at: 0)
                let notFindHistory = MergeHistory(number: history.number, state: history.state, theSameHistory: theSameHistory)
                dealArray.insert(notFindHistory, at: 0)
            }
        }
        
        return dealArray
    }
}

struct Contact {
    let name: String
    let iconImage: Image
}


struct MergeHistory: Hashable {
    var number: String
    var state: HistoryState
    var theSameHistory: [YLSHistory]
}
