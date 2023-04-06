//
//  UIView+Alert.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/19.
//

#import <objc/runtime.h>
#import "UIView+Alert.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"

@implementation UIView (Alert)

#pragma mark - HUD

- (void)setupConfigurator {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setRingThickness:3];
    [SVProgressHUD  setMinimumSize:CGSizeMake(100.f, 100.f)];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRGB:0xD7D6D7]];
}


- (void)showHUD {
    [self setupConfigurator];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
}

- (void)showHUDWithText:(NSString *)text {
    [self setupConfigurator];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:text];
}

- (void)showHUDInfoWithText:(NSString *)text {
     [self setupConfigurator];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showInfoWithStatus:text];
}

- (void)showHUDSuccessWithText:(NSString *)text {
     [self setupConfigurator];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showSuccessWithStatus:text];
}

- (void)showHUDErrorWithText:(NSString *)text {
     [self setupConfigurator];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showErrorWithStatus:text];
}


- (void)hideHUD {
    [SVProgressHUD dismiss];
}


#pragma mark - Toast

static void *ToastKEY = &ToastKEY;

- (UIView *)toastView {
    return objc_getAssociatedObject(self, ToastKEY);
}

- (void)setToastView:(UIView *)toastView {
    objc_setAssociatedObject(self, ToastKEY, toastView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showToastWithText:(NSString *)toastString {
    [self showToastWithText:toastString positon:CSToastPositionCenter];
}

- (void)showToastWithText:(NSString *)toastString positon:(id)positon {
    
    if (toastString.length > 0) {
        
        if (![self toastView]) {
            [CSToastManager setQueueEnabled:NO];
            [CSToastManager sharedStyle].backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            [CSToastManager sharedStyle].verticalPadding = 20;
            [CSToastManager sharedStyle].horizontalPadding = 18;
        }
        
        UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
        UIView *toastView = [keyWindow toastViewForMessage:toastString title:nil image:nil style:nil];
        [UIView animateWithDuration:0.3 animations:^{
            [self toastView].alpha = 0 ;
        } completion:^(BOOL finished) {
            [[self toastView] removeFromSuperview];
            [self setToastView:toastView];
        }];
        [keyWindow showToast:toastView duration:2 position:positon completion:nil];
    }
}

- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showToastWithText:toastString];
    });
}

@end

@implementation UIViewController (Alert)

- (void)showHUD {
    [self.view showHUD];
}

- (void)showHUDWithText:(NSString *)text {
    [self.view showHUDWithText:text];
}

- (void)showHUDInfoWithText:(NSString *)text {
    [self.view showHUDInfoWithText:text];
}

- (void)showHUDSuccessWithText:(NSString *)text {
    [self.view showHUDSuccessWithText:text];
}

- (void)showHUDErrorWithText:(NSString *)text {
     [self.view showHUDErrorWithText:text];
}

- (void)hideHUD {
    [self.view hideHUD];
}

- (void)showToastWithText:(NSString *)toastString {
    [self.view showToastWithText:toastString];
}

- (void)showToastWithText:(NSString *)toastString positon:(id)positon {
    [self.view showToastWithText:toastString positon:positon];
}

- (void)showToastWithText:(NSString *)toastString afterDelay:(NSTimeInterval)timeInterval {
    [self.view showToastWithText:toastString afterDelay:timeInterval];
}

@end
