//
//  Contact.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/29.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject<YLSContactProtocol>

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) UIImage *iconImage;

@end
