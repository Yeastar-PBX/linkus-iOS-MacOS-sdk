//  CallWaitingView.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#import <UIKit/UIKit.h>

@class CallWaitingView;

@protocol CallWaitingViewDelegate <NSObject>

@optional

- (void)callWaitingView:(CallWaitingView *)waitingView callInfo:(YLSSipCall *)SipCall;

@end

@interface CallWaitingView : UIView

@property (nonatomic,weak) id<CallWaitingViewDelegate> delegate;

- (void)callNormal:(YLSSipCall *)currentCall;

@end
