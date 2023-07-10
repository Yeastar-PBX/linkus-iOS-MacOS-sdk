//
//  ConfBottomView.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/5.
//

#import <UIKit/UIKit.h>

@class ConfBottomView;

@protocol ConfBottomViewDelegate <NSObject>

- (void)conferenceHangup;

- (void)conferenceMute:(BOOL)select;

@end

@interface ConfBottomView : UIView

@property (nonatomic,weak) id<ConfBottomViewDelegate> delegate;

@property (nonatomic,strong) UIButton *muteButton;

@end
