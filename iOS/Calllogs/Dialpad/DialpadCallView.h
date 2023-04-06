//
//  DialpadCall.h
//  Linkus
//
//  Created by 杨桂福 on 2021/1/12.
//  Copyright © 2021 Yeastar Technology Co., Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>

@class DialpadCallView;

@protocol DialpadCallViewDelegate <NSObject>

@optional

- (void)dialpadCallViewCallAction:(DialpadCallView *)dialpadCallView touchAction:(BOOL)longTouch;

- (void)dialpadCallViewShowAction:(DialpadCallView *)dialpadCallView;

@end

@interface DialpadCallView : UIView

@property (nonatomic,  weak) id<DialpadCallViewDelegate> delegate;

@property (nonatomic,assign) BOOL                        dialpadShow;

@end
