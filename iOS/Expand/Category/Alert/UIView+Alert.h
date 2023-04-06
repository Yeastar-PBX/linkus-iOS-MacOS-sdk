//
//  UIView+Alert.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/19.
//

#import <UIKit/UIKit.h>

@protocol Alert <NSObject>

- (void)showHUD;
- (void)showHUDWithText:(NSString *)text;
- (void)showHUDInfoWithText:(NSString *)text;
- (void)showHUDSuccessWithText:(NSString *)text;
- (void)showHUDErrorWithText:(NSString *)text;
- (void)hideHUD;

- (void)showToastWithText:(NSString *)toastString;
- (void)showToastWithText:(NSString *)toastString positon:(id)positon;
- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval;

@end

@interface UIView (Alert)<Alert>
@end

@interface UIViewController (Alert)<Alert>
@end
