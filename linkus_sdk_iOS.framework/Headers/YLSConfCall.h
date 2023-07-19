//
//  YLSConfCall.h
//  linkus-sdk
//
//  Created by 杨桂福 on 2023/7/5.
//

#import <Foundation/Foundation.h>
#import "YLSCallProtocol.h"
#import "YLSConfMember.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLSConfCall : NSObject

@property (nonatomic,copy) NSString *host;

@property (nonatomic,copy) NSString *meetname;

@property (nonatomic,copy) NSString *confid;

@property (nonatomic,copy) NSString *datetime;

@property (nonatomic,strong) NSMutableArray<NSString *> *members;

@property (nonatomic,strong) YLSConfMember *hostMember;

@property (nonatomic,strong) NSMutableArray<YLSConfMember *> *confMembers;

@property (nonatomic,strong) NSMutableArray<NSString *> *inviteMembers;

@end

NS_ASSUME_NONNULL_END
