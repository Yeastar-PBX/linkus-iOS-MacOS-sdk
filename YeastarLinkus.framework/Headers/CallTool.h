//
//  YSLCallTool.h
//  Linkus
//
//  Created by 杨桂福 on 2023/3/14.
//

#import <Foundation/Foundation.h>
#import "YLSSipCall.h"

@interface CallTool : NSObject

+ (instancetype)shareCallTool;

//通话操作
- (void)reportIncomingCall:(YLSSipCall *)sipCall completion:(void (^)(void))completion error:(void (^)(NSError *error))errorBlock;

- (void)startCall:(YLSSipCall *)sipCall completion:(void (^)(NSError *error))completion;

- (void)answerCall:(YLSSipCall *)sipCall;

- (void)endCall:(YLSSipCall *)sipCall;

- (void)endAllCall;

//通话内操作
- (void)setHeld:(YLSSipCall *)sipCall;
- (void)setHeld:(YLSSipCall *)sipCall onHold:(BOOL)onHold;

- (void)setMute:(YLSSipCall *)sipCall;

- (BOOL)setRecord:(YLSSipCall *)sipCall;

- (void)setDTMF:(YLSSipCall *)sipCall string:(NSString *)str;

//转移操作
- (void)transferConsultation:(YLSSipCall *)sipCall;

- (void)tranforBlind:(YLSSipCall *)sipCall;

@end
