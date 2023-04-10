//
//  YLSPJRegister.h
//  Linkus
//
//  Created by 杨桂福 on 2023/3/14.
//

#import <linkus_vivo/YLSCallProtocol.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
