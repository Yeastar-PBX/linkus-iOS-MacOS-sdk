//
//  DialKeypadView.h
//  Linkus
//
//  Created by 杨桂福 on 2022/11/24.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DialKeypadViewDelegate <NSObject>

@optional

- (void)dialKeypadViewCancel:(UIButton *)button;

- (void)dialKeypadViewContacts:(UIButton *)button;

- (void)dialKeypadViewHistory:(UIButton *)button;

- (void)dialKeypadViewTransferTo:(NSString *)text;

- (void)dialKeypadViewDtmf:(NSString*)str;

@end

@interface DialKeypadView : UIView

@property (nonatomic,weak) id<DialKeypadViewDelegate> delegate;

@property (nonatomic,assign) BOOL dtmf;

@end
