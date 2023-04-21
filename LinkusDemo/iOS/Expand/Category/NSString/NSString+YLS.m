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

+ (NSString *)timeCompare:(NSString *)timeStamp {
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
    NSString *result = @"";
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSInteger hour = msgDateComponents.hour;
    double OnedayTimeIntervalValue = 24*60*60;  //一天的秒数
    
    BOOL isSameMonth = (nowDateComponents.year == msgDateComponents.year) && (nowDateComponents.month == msgDateComponents.month);
    if(isSameMonth && (nowDateComponents.day == msgDateComponents.day)) //同一天,显示时间
    {
        result = [self getPeriodOfTime:hour withMinute:msgDateComponents.minute];
    }
    else if(isSameMonth && (nowDateComponents.day == (msgDateComponents.day+1)))//昨天
    {
        result = @"Yesterday";
    }
    else if([nowDate timeIntervalSinceDate:msgDate] < 7 * OnedayTimeIntervalValue)//一周内
    {
        result = [self weekdayStr:msgDateComponents.weekday];
    }
    else//显示日期
    {
        result = [NSString stringWithFormat:@"%ld-%02d-%02d", (long)msgDateComponents.year, (int)msgDateComponents.month, (int)msgDateComponents.day];
    }
    return result;
}

+ (NSString *)getPeriodOfTime:(NSInteger)time
                   withMinute:(NSInteger)minute {
    NSString *formatStringForHours=[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA=[formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM=containsA.location!=NSNotFound;
    NSString *showPeriodOfTime = @"";
    if (hasAMPM == true) {
        NSInteger totalMin = time *60 + minute;
        if (totalMin > 0 && totalMin < 12 * 60) {
            if (time == 0) {
                showPeriodOfTime = [[NSString alloc] initWithFormat:@"%d:%02d AM",12,(int)minute];
            }else{
                showPeriodOfTime = [[NSString alloc] initWithFormat:@"%d:%02d AM",(int)time,(int)minute];
            }
        }else if ((totalMin >= 12 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)         {
            if (time == 12) {
                showPeriodOfTime = [[NSString alloc] initWithFormat:@"%d:%02d PM",(int)(time),(int)minute];
            }else{
                showPeriodOfTime = [[NSString alloc] initWithFormat:@"%d:%02d PM",(int)(time - 12),(int)minute];
            }
        }
    }else{
        showPeriodOfTime = [[NSString alloc] initWithFormat:@"%d:%02d",(int)time,(int)minute];
    }
    return showPeriodOfTime;
}

+ (NSString*)weekdayStr:(NSInteger)dayOfWeek {
    static NSDictionary *daysOfWeekDict = nil;
    daysOfWeekDict = @{@(1) : @"Sunday",
                       @(2) : @"Monday",
                       @(3) : @"Tuesday",
                       @(4) : @"Wednesday",
                       @(5) : @"Thursday",
                       @(6) : @"Friday",
                       @(7) : @"Saturday"};
    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
}

@end
