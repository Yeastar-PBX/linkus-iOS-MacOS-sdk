//
//  UITextField+YLS.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/21.
//

#import <UIKit/UIKit.h>

@interface UITextField (YLS)

- (void)ys_updateText:(NSString *)text;

@property (nonatomic, assign) NSRange ys_selectedRange;

@end
