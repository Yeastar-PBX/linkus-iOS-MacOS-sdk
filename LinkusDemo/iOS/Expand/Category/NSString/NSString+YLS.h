//
//  NSString+YLS.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/21.
//

#import <Foundation/Foundation.h>

@interface NSString (YLS)

+ (NSString *)holdTimeHoursMinutesSecond:(NSTimeInterval)holdTime;

+ (NSString *)smartTranslation:(NSString *)string;

@end
