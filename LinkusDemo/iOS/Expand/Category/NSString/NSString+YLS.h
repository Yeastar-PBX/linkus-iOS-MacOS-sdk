//
//  NSString+YLS.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/21.
//

#import <Foundation/Foundation.h>

@interface NSString (YLS)

+ (NSString *)holdTimeHoursMinutesSecond:(NSTimeInterval)holdTime;

+ (NSString *)timeFormatted:(int)totalSeconds;

+ (NSString *)smartTranslation:(NSString *)string;

+ (NSString *)timeCompare:(NSString *)timeStamp;

+ (void)pushNotificationWithTitle:(NSString *)title body:(NSString *)body identifier:(NSString *)identifier;

@end
