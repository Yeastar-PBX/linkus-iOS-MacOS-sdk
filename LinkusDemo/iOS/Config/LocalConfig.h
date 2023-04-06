//
//  LocalConfig.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#ifndef LocalConfig_h
#define LocalConfig_h

//软件版本号
#define LinkusVersionNum      @"5.0.10"

// 根TabBarController
#define RootTabBarController \
((UITabBarController *)[[UIApplication sharedApplication] delegate].window.rootViewController)

// 当前顶层NavigationController
#define TopestNavigationController \
(TopestViewController.navigationController)

// 当前顶层Controller
#define TopestViewController \
([UIViewController topViewController])

//字典容错
#define SafeDicObject(object) \
object ? : [NSNull null]


#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define LocalizedString(key, ...) [NSString ys_localizedStringFormat:(key), ## __VA_ARGS__]

//尺寸
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenScale (ScreenWidth - 64)/(375 - 64)

#define iPhoneX    ([UIDevice currentDevice].isPhoneXSeries)
#define StatusBarHeight         (iPhoneX ? 44.f : 20.f)
#define TabBarOffset            (iPhoneX ? 34.f : 0.f)


#endif /* LocalConfig_h */
