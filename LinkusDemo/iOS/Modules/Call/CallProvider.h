//
//  CallProvider.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DialCallType) {
    DialCallTypeNormal        = 0,
    DialCallTypeTransfer      = 1,
    DialCallTypeBlind         = 2,
};

@interface CallProvider : NSObject

@property (nonatomic, assign) DialCallType dialCallType;

+ (instancetype)shareCallProvider;

+ (void)baseCallByNumber:(NSString *)number;

@end
