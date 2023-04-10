//
//  LoginAutoObserver.h
//  Linkus
//
//  Created by 杨桂福 on 2023/3/14.
//

#import <Foundation/Foundation.h>

@interface NetWorkStatusObserver : NSObject

+ (instancetype)sharedNetWorkStatusObserver;

- (void)startMonitoring;

- (void)stopMonitoring;

- (void)applicationReceivePush;

@end
