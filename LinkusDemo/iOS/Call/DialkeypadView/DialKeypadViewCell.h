//
//  DialKeypadViewCell.h
//  Linkus
//
//  Created by 杨桂福 on 2022/11/24.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DialKeypadViewCell;

@protocol DialKeypadViewCellDelegate <NSObject>

@optional

- (void)dialKeypadViewCell:(DialKeypadViewCell *)dialKeypadViewCell numberTouch:(NSString *)number;

- (void)dialKeypadViewCell:(DialKeypadViewCell *)dialKeypadViewCell numberUpdate:(NSString *)number;

@end

@interface DialKeypadViewCell : UICollectionViewCell

@property (nonatomic,weak)    id<DialKeypadViewCellDelegate> delegate;

@property (nonatomic,copy)    NSString        *name;

@property (nonatomic,copy)    NSString        *number;

@end
