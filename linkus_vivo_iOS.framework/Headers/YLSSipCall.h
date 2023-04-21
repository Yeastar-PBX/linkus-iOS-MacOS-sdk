//
//  YLSSipCall.h
//  Linkus
//
//  Created by 杨桂福 on 2023/3/15.
//

#import <Foundation/Foundation.h>
#import "YLSCallProtocol.h"

@class YLSHistory;

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

typedef void(^hasConnectedDidChange)(void);
typedef void(^hasAnswerCallSuc)(void);

@interface YLSSipCall : NSObject

@property (nonatomic,copy)    NSString *callNumber;

@property (nonatomic,strong)  id<YLSContactProtocol> contact;

@property (nonatomic,copy)   NSString *serverName;

@property (nonatomic,assign) BOOL mute;

@property (nonatomic,assign) BOOL onHold;

@property (nonatomic,assign)  CallStatus status;

@property (nonatomic,assign)  HangUpType hangUpType;

@property (nonatomic,assign) NSTimeInterval durationTime;

@property (nonatomic,assign) NSTimeInterval holdTime;


#pragma mark - 对SDK使用
@property (nonatomic,strong) YLSHistory *historyCDR;//cdr生成

@property (nonatomic,assign)  int callID;

@property (nonatomic,assign)  BOOL callIn;

@property (nonatomic,copy)    NSString *callIdStr;

@property (nonatomic,assign)  BOOL autoAnswer;

@property (nonatomic,assign) BOOL callRecordConferenceType;

@property (nonatomic,assign) CallRecordType callRecordType;

@property (nonatomic,strong) NSUUID *uuid;

@property (nonatomic,copy)   NSString *linkedid;

@property (nonatomic,assign) BOOL tryRegister;

@property (nonatomic,assign) BOOL answeredElsewhere;

@property (nonatomic,copy)   NSString *startTimeStamp;

@property (nonatomic,copy) hasConnectedDidChange hasConnectedDidChangeBlock;

@property (nonatomic,copy) hasAnswerCallSuc answercallSuc;

- (BOOL)isPlayHangupVoice;

@end

NS_ASSUME_NONNULL_END
