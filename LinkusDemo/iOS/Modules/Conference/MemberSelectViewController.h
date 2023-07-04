//
//  MemberSelectViewController.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/4.
//

#import <UIKit/UIKit.h>

typedef void(^SurePicture)(NSString *number);

@interface MemberSelectViewController : UIViewController

@property (nonatomic,copy) SurePicture block;

@end
