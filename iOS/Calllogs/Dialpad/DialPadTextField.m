//
//  DialPadTextField.m
//  Linkus
//
//  Created by 杨桂福 on 2021/1/11.
//  Copyright © 2021 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "DialPadTextField.h"
#import "NSString+YLS.h"

@implementation DialPadTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [super canPerformAction:action withSender:sender];
}

- (void)paste:(id)sender {
    NSString *string = [UIPasteboard generalPasteboard].string;
    NSString *number = [NSString smartTranslation:string];
    [self ys_updateText:number];
}

@end
