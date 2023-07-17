//
//  ConfHistoryBuild.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/14.
//

#import <Foundation/Foundation.h>

@protocol ConfHistoryBuildDelegate <NSObject>

- (void)conferenceHistoryUpdate:(NSArray<YLSConfCall *> *)conferenceHistorys;

@end

@interface ConfHistoryBuild : NSObject

@property (nonatomic,weak) id<ConfHistoryBuildDelegate> delegate;

+ (instancetype)shareConfHistoryBuild;

- (NSArray<YLSConfCall *> *)conferenceHistorys;

- (void)conferenceHistoryDelete:(YLSConfCall *)model;

@end
