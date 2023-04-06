//
//  NSString+YLS.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/21.
//

#import "NSString+YLS.h"

@implementation NSString (YLS)

+ (NSString *)smartTranslation:(NSString *)string {
    NSString *filter =  [[string componentsSeparatedByCharactersInSet:
                          [[NSCharacterSet characterSetWithCharactersInString:@"0123456789*+#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet]]
                         componentsJoinedByString:@""];
    NSMutableString *mapper = [NSMutableString string];
    for (int i = 0; i < [filter length]; i++) {
        unichar curChar = [filter characterAtIndex:i];
        if ( curChar >= '0' && curChar <= '9') {
            [mapper appendString:[NSString stringWithFormat:@"%C",curChar]];
        }else if (curChar == '*' || curChar == '+'|| curChar == '#'){
            [mapper appendString:[NSString stringWithFormat:@"%C",curChar]];
        }else{
            int distance = 0;
            if (curChar >= 'A' && curChar <= 'Z'){
                distance = curChar - 'A';
                
            }else if (curChar >= 'a' && curChar <= 'z'){
                distance = curChar - 'a';
            }else
            continue;//protect
            int map = distance / 3;
            if (distance == 18 || distance == 21) {
                map += 1;
            }else{
                map += 2;
            }
            if (map > 9) {
                map = 9;
            }
            [mapper appendString:[NSString stringWithFormat:@"%d",map]];
        }
    }
    return mapper;
}

+ (NSString *)holdTimeHoursMinutesSecond:(NSTimeInterval)holdTime {
    if (holdTime > 0) {
        int scd = [[NSDate date] timeIntervalSince1970] - holdTime;
        int seconds = scd % 60;
        int minutes = (scd / 60) % 60;
        int hours = scd / 3600;
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
        }else{
            return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
        }
    }else{
        return @"00:00";
    }
}

@end
