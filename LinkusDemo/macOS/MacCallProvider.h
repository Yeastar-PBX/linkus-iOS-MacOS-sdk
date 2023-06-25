//
//  MacCallProvider.h
//  LinkusDemo (macOS)
//
//  Created by 杨桂福 on 2023/4/25.
//

#import <Foundation/Foundation.h>
#import <linkus_sdk_MacOS/linkus_sdk.h>

@protocol MacCallProviderDelegate <NSObject>

@optional

- (void)popCallView;

- (void)dismissCallView;

- (void)reloadCurrentCall:(YLSSipCall *)sipCall;

- (void)loginOut;

@end


@interface MacCallProvider : NSObject

@property (nonatomic,weak) id<MacCallProviderDelegate> delegate;

+ (instancetype)shareCallProvider;

@end
