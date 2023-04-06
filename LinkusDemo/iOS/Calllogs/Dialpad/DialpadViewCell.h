//
//  DiapadViewCell.h
//  Linkus
//
//  Created by 杨桂福 on 2021/1/11.
//  Copyright © 2021 Yeastar Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DialpadViewCell;

@protocol DialpadViewCellDelegate <NSObject>

@optional

- (void)dialpadViewCell:(DialpadViewCell *)dialpadViewCell numberTouch:(NSString *)number;

- (void)dialpadViewCell:(DialpadViewCell *)dialpadViewCell numberUpdate:(NSString *)number;

@end

@interface DialpadViewCell : UICollectionViewCell

@property (nonatomic,weak)    id<DialpadViewCellDelegate> delegate;

@property (nonatomic,copy)    NSString        *name;

@property (nonatomic,copy)    NSString        *number;

@end
