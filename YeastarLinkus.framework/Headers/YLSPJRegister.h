//
//  YLSPJRegister.h
//  Linkus
//
//  Created by 杨桂福 on 2023/3/14.
//

#import <Foundation/Foundation.h>

@class YLSPJRegister;

@protocol PJRegisterDelegate <NSObject>

@optional

//通话状况：Yes 差   No 好
- (void)pjRegister:(YLSPJRegister *)pjRegister callid:(int)callid callStatus:(BOOL)quality;

@end

@interface YLSPJRegister : NSObject

+ (instancetype)sharePJRegister;

@property (nonatomic,assign,readonly) int register_id;

@property (nonatomic,assign) BOOL isSucRegis;

@property (nonatomic,assign) BOOL isRegistering;

+ (void)registerPJSip;

+ (void)audioSendSetDev;

- (void)addDelegate:(id<PJRegisterDelegate>)delegate;

- (void)removeDelegate:(id<PJRegisterDelegate>)delegate;

@end
