//
//  YLSConfMember.h
//  linkus-sdk
//
//  Created by 杨桂福 on 2023/7/6.
//

#import <Foundation/Foundation.h>
#import "YLSCallProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  会议室通话状态
 */
typedef NS_ENUM(NSUInteger, ConferenceCallingStatus) {
    ConferenceCallingStatusRinging            = 0,//0.响铃
    ConferenceCallingStatusBridge             = 1,//1.接听
    ConferenceCallingStatusMissedCall         = 5,//5.未接来电
    ConferenceCallingStatusAbnormalDropping   = 6,//6.异常掉线
    ConferenceCallingStatusLeave              = 2,//2.离开会议室
};

/**
 *  会议室语音状态
 */
typedef NS_ENUM(NSUInteger, ConferenceSpeakerOperate) {
    ConferenceSpeakerOperateMute      = 3,//3.静音
    ConferenceSpeakerOperateUnmute    = 4,//4.取消静音
};


@interface YLSConfMember : NSObject

@property (nonatomic,copy) NSString *number;

@property (nonatomic,assign) ConferenceCallingStatus status;      //状态

@property (nonatomic,assign) ConferenceSpeakerOperate operate;    //操作

@property (nonatomic,strong) id<YLSContactProtocol> contact;

@end

NS_ASSUME_NONNULL_END
