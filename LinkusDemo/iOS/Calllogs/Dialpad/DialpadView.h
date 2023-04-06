//
//  DialpadView.h
//  Linkus
//
//  Created by 杨桂福 on 2021/1/11.
//  Copyright © 2021 Yeastar Technology Co., Ltd. All rights reserved.
//

#import <HWPanModal/HWPanModal.h>

@class DialpadView;

@protocol DialpadViewDelegate <NSObject>

@optional

- (void)dialpadViewHidden:(DialpadView *)dialpadView;

- (void)dialpadView:(DialpadView *)dialpadView personNumberAdd:(NSString *)number;

- (void)dialpadView:(DialpadView *)dialpadView searchNumber:(NSString *)number;

@end

@interface DialpadView : HWPanModalContentView

@property (nonatomic,weak) id<DialpadViewDelegate> delegate;

@property (nonatomic,weak) id<DialpadViewDelegate> searchDelegate;

@property (nonatomic,copy) NSString *number;

- (void)clearTextField;

@end
