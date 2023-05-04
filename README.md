![linkus-vivo.GIF](https://github.com/Yeastar-PBX/linkus-ios-sdk-vivo/blob/main/linkus-vivo.gif)
![linkus-vivo.GIF](https://github.com/Yeastar-PBX/linkus-ios-sdk-vivo/blob/main/MacOS.gif)

# linkus-vivo SDK 接入指南

## 一. SDK 集成
系统要求：
`iOS 11`
`MacOS 10.13`
MacOS是用SwiftUI实现的，因此要求`Xcode 14.3`

Linkus提供两种集成方式供开发者选择：

- CocoaPods
- 手动集成

#### 1.1 CocoaPods集成方式

在iOS工程的Podfile里面添加以下代码：
> **pod 'linkus-vivo'**

在MacOS工程的Podfile里面添加以下代码：
> **pod 'linkus-vivo-MacOS'**

保存并执行`pod install`,然后用后缀为`.xcworkspace`的文件打开工程。

关于`CocoaPods`的更多信息请查看[CocoaPods官方网站](https://cocoapods.org/)。

#### 1.2 手动集成方式

* 下载[iOS SDK](https://github.com/Yeastar-PBX/linkus-ios-sdk-vivo/tree/main/linkus_vivo_iOS.framework) 
* 拖拽`linkus_vivo_iOS.framework`文件到Xcode工程内(请勾选`Copy items if needed`选项)
* 添加依赖库
    - `libc++.dylib`
    - `libxml2.dylib`
    - `libresolvdylib`
    
* 下载[MacOS SDK](https://github.com/Yeastar-PBX/linkus-ios-sdk-vivo/tree/main/linkus_vivo_MacOS.framework) 
* 拖拽`linkus_vivo_MacOS.framework`文件到Xcode工程内(请勾选`Copy items if needed`选项)
* 添加依赖库
    - `libcurl.dylib`
    - `libxml2.dylib`

## 二. 初始化SDK

#### 2.1 导入头文件

在工程的`PrefixHeader.pch`文件导入头文件

> `#import <linkus_vivo_iOS/linkus_vivo.h>` 或者 `#import <linkus_vivo_MacOS/linkus_vivo.h>`

#### 2.2 初始化iOS SDK

在工程`AppDelegate.m`的`application:didFinishLaunchingWithOptions:`方法中初始化：

- **Objective-C**

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[YLSSDK sharedYLSSDK] initApp];
    return YES;
}
```

#### 2.3 初始化MacOS SDK,参考Demo

# Linkus SDK 使用指南
## 一. 接口声明

### 1. 配置
```
/**
 *  配置项
 */
+ (instancetype)sharedConfig;

/// Localized name of the provider
@property (nonatomic,copy,nullable) NSString *localizedName;

/// Image should be a square with side length of 40 points
@property (nonatomic,copy,nullable) NSData *iconTemplateImageData;

/// 来电声音频文件
@property (nonatomic,copy) NSString *comeAudioFileName API_AVAILABLE(macos(10.13));

/// 挂断声音频文件
@property (nonatomic,copy) NSString *hangupAudioFileName;

/// 呼叫等待声音频文件
@property (nonatomic,copy) NSString *alertAudioFileName;

```

### 2. 登录接口
```
/**
 *  登录
 */
- (void)login:(NSString *)account token:(NSString *)token localIP:(NSString *)localIP localPort:(NSString *)localPort
     remoteIP:(NSString *)remoteIP remotePort:(NSString *)remotePort completion:(void (^)(NSError * _Nullable error))completion;

/**
 *  自动登录
 */
- (void)autoLogin API_AVAILABLE(ios(11.0));

/**
 *  登出
 */
- (void)logout:(void (^)(NSError * _Nullable error))completion;

/**
 *  登录回调
 */
- (void)onLoginStep:(LoginStep)step;

/**
 *  被踢(服务器/其他端)回调
 */
- (void)onKickStep:(KickReason)code;

```

### 3. 通话接口
```
/**
 *  发起通话
 */
- (void)startCall:(YLSSipCall *)sipCall completion:(void (^)(NSError *error))completion;

/**
 *  结束通话
 */
- (void)endCall:(YLSSipCall *)sipCall;

/**
 *  Hold
 */
- (void)setHeld:(YLSSipCall *)sipCall;

/**
 *  静音
 */
- (void)setMute:(YLSSipCall *)sipCall;

/**
 *  录音
 */
- (BOOL)setRecord:(YLSSipCall *)sipCall;

/**
 *  咨询转
 */
- (void)transferConsultation:(YLSSipCall *)sipCall;

/**
 *  盲转
 */
- (void)tranforBlind:(YLSSipCall *)sipCall;

/**
 *  通话质量
 */
- (NSString *)callQuality;

```

### 4. 通话信息
```
/**
 *  处理Voip推送
 */
- (void)receiveIncomingPushWithPayload:(NSDictionary *)dictionaryPayload;

/**
 *  正在进行的通话信息
 */
- (YLSSipCall *)currentSipCall;

/**
 *  所有通话信息
 */
- (NSArray<YLSSipCall *> *)currentSipCalls;

/**
 *  获取MacOS 麦克风与扬声器
 */
- (NSArray<YLSCaptureDevice *> *)audioALLDevice API_AVAILABLE(macos(10.13));

/**
 *  设置MacOS 麦克风与扬声器
 */
- (void)audioSetDevice:(NSInteger)microphone speaker:(NSInteger)speaker API_AVAILABLE(macos(10.13));

/**
 *  Sip 注册状态
 */
- (BOOL)sipRegister;

/**
 *  录音功能是否可用
 */
- (BOOL)enableRecord;

/**
 *  管理员录音功能
 */
- (BOOL)adminRecord;

/**
 *  添加委托
 */
- (void)addDelegate:(id<YLSCallManagerDelegate>)delegate;

/**
 *  移除委托
 */
- (void)removeDelegate:(id<YLSCallManagerDelegate>)delegate;

/**
 *  来电回调
 */
- (void)callManager:(YLSCallManager *)callManager contact:(void (^)(id<YLSContactProtocol> (^block)(NSString *number)))contact completion:(void (^)(void (^controllerBlock)(void),void (^errorBlock)(NSError *error)))completion;

/**
 *  通话信息变更回调
 */
- (void)callManager:(YLSCallManager *)callManager callInfoStatus:(NSMutableArray<YLSSipCall *> *)currenCallArr;

/**
 *  Sip错误码回调
 */
- (void)callManager:(YLSCallManager *)callManager callFaild:(NSError *)error;

/**
 *  录音状态回调
 */
- (void)callManagerRecordType:(YLSCallManager *)callManager;

/**
 *  当前通话质量回调
 */
- (void)callManager:(YLSCallManager *)callManager callQuality:(BOOL)quality;

```

### 5. 通话类型、呼叫等待、呼叫转移
```
/**
 *  呼叫等待切换通话
 */
- (void)callChange:(YLSSipCall *)waitingCall;

/**
 *  添加委托
 */
- (void)addDelegate:(id<YLSCallStatusManagerDelegate>)delegate;

/**
 *  移除委托
 */
- (void)removeDelegate:(id<YLSCallStatusManagerDelegate>)delegate;

/**
 *  挂断所有通话
 */
- (void)callStatusManagerDissmiss:(YLSCallStatusManager *)callStatusManager;

/**
 *  普通来电
 */
- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall;

/**
 *  呼叫等待转移
 */
- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall
              callWaiting:(nullable YLSSipCall *)callWaitingCall transferCall:(nullable YLSSipCall *)transferCall;

```

### 6. 历史记录
```
/**
 *  历史记录信息
 */
- (NSArray<YLSHistory *> *)historys;

/**
 *  删除历史记录
 */
- (void)historyManagerRemove:(NSArray<YLSHistory *> *)historys;

/**
 *  删除所有历史记录
 */
- (void)historyManagerRemoveAll;

/**
 *  标记已读
 */
- (void)checkMissedCalls;

/**
 *  历史记录变更回调
 */
- (void)historyReload:(NSMutableArray<YLSHistory *> *)historys;

/**
 *  未接来电数量变更回调
 */
- (void)historyMissCallCount:(NSInteger)count;

```


# 更新日志
- 20230428 提交尚未测试过的开源库，版本号：1.0.0
