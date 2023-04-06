//
//  UIDevice+YLS.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/28.
//

#import "UIDevice+YLS.h"

@implementation UIDevice (YLS)

- (BOOL)isPhoneXSeries {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

@end
