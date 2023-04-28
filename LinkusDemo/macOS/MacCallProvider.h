//
//  MacCallProvider.h
//  LinkusDemo (macOS)
//
//  Created by 杨桂福 on 2023/4/25.
//

#import <Foundation/Foundation.h>
#import <linkus_vivo_MacOS/linkus_vivo.h>

@protocol MacCallProviderDelegate <NSObject>

@optional

- (void)popCallView;

- (void)dismissCallView;

- (void)reloadCurrentCall:(YLSSipCall *)sipCall;

@end


@interface MacCallProvider : NSObject

@property (nonatomic,weak) id<MacCallProviderDelegate> delegate;

+ (instancetype)shareCallProvider;

@end
