//
//  ConfTopView.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/5.
//

#import <UIKit/UIKit.h>

@class ConfTopView;

@protocol ConfTopViewDelegate <NSObject>

- (void)clickAvatar;

@end

@interface ConfTopView : UIView

@property (nonatomic,weak) id<ConfTopViewDelegate> delegate;

@end
