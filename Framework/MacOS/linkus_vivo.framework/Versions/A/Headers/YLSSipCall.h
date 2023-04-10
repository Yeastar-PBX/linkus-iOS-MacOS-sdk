//
//  YLSSipCall.h
//  Linkus
//
//  Created by 杨桂福 on 2023/3/15.
//

#import <Foundation/Foundation.h>
#import <linkus_vivo/YLSCallProtocol.h>

NS_ASSUME_NONNULL_BEGIN

#define DefaultSipCallID       -1 //本地默认通话ID为-1

typedef NS_ENUM(NSInteger, CallStatus) {
    CallStatusNoNetwork        = 0, //sip连接失败
    CallStatusConnect          = 1, //callKit接通来电，连接服务器中
    CallStatusCalling          = 2, //正在拨号
    CallStatusRemoteRinging    = 3, //表示对方正在响铃中
    CallStatusBridge           = 4, //桥接通话，通话建立
};

typedef NS_ENUM(NSInteger, HangUpType) {
    HangUpTypeByPJSip           = 1, //pjsip发送过来的挂断通话
    HangUpTypeByHand            = 2, //手动挂断通话
    HangUpTypeByMissCall        = 3, //推送挂断通话
};

typedef NS_ENUM(NSInteger, CallRecordType) {
    CallRecordTypeStop                     = 0,
    CallRecordTypeRecording                = 1,
    CallRecordTypePause                    = 2,
    CallRecordTypeConferenceRecording      = 3,
};

typedef NS_ENUM(NSInteger, CallType) {
    CallTypeNormal        = 0,
    CallTypeRingGroup     = 1,
    CallTypeQueue         = 2,
};

typedef NS_ENUM(NSInteger, CallAutoAnswerType) {
    CallAutoAnswerTypeNormal                   = 0,
    CallAutoAnswerTypeTalkbackOrBroadcast      = 1,
    CallAutoAnswerTypeConference               = 2,
};

typedef void(^hasConnectedDidChange)(void);
typedef void(^hasAnswerCallSuc)(void);

@interface YLSSipCall : NSObject

@property (nonatomic,assign)  struct callerinfo *callerinfo;

@property (nonatomic,assign)  int call_ID;

@property (nonatomic,assign)  BOOL call_in;

@property (nonatomic,copy)    NSString *callIdStr;

@property (nonatomic,assign)  BOOL autoAnswer;

@property (nonatomic,copy)    NSString *call_num;

@property (nonatomic,assign)  CallStatus status;

@property (nonatomic,assign)  HangUpType hangUpType;

@property (nonatomic,strong)  id<YLSContactProtocol> contact;

@property (nonatomic,copy)   NSString *serverName;

@property (nonatomic,copy)   NSString *sipTrunkName;

@property (nonatomic,copy)   NSString *companyName;

@property (nonatomic,assign) NSUInteger durationTime;

@property (nonatomic,assign) NSTimeInterval holdTime;

@property (nonatomic,assign) BOOL holdVideo;

//P系列全局录音
@property (nonatomic,assign) BOOL callRecordConferenceType;

@property (nonatomic,assign) CallRecordType callRecordType;

@property (nonatomic,assign) BOOL mute;

@property (nonatomic,assign) BOOL remoteMute;

@property (nonatomic,assign) BOOL onHold;

@property (nonatomic,assign) BOOL speaker;

//@property (nonatomic,strong) History *historyCDR;//cdr生成

@property (nonatomic,assign) BOOL donotCreateCDR;//是否不生成CDR

@property (nonatomic,strong) NSUUID *uuid;

@property (nonatomic,copy)   NSString *callPrefix;//前缀

@property (nonatomic,copy)   NSString *linkedid;//推送标识

@property (nonatomic,assign) BOOL tryRegister;//是否正在连接服务器

@property (nonatomic,assign) BOOL routeLocal;//前缀是否是本地生成的

@property (nonatomic,assign) BOOL answeredElsewhere;//是否其它端接听

@property (nonatomic,assign) CallType callType;//来电类型

@property (nonatomic,assign) CallAutoAnswerType autoAnswerType;//来电类型

@property (nonatomic,copy)   NSString *startTimeStamp;//来电创建的时间

//打电话，连接成功记数的回调
@property (nonatomic,copy) hasConnectedDidChange hasConnectedDidChangeBlock;

//用于推送来电先弹出界面 有时候接听没连上服务器 这里需要回调通知callkit状态变更
@property (nonatomic,copy) hasAnswerCallSuc answercallSuc;

//是否需要播放挂断提示音
- (BOOL)isPlayHangupVoice;

@end

NS_ASSUME_NONNULL_END
