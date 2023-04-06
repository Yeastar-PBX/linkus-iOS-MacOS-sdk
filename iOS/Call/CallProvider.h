//
//  CallProvider.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#import <Foundation/Foundation.h>

@interface CallProvider : NSObject

+ (instancetype)shareCallProvider;

+ (void)baseCallByNumber:(NSString *)number;

@end
