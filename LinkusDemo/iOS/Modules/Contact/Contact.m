//
//  Contact.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/29.
//

#import "Contact.h"
#import "UIImage+YLS.h"

@implementation Contact

- (UIImage *)iconImage {
    if (!_iconImage) {
        _iconImage = [UIImage imageWithText:self.name];
    }
    return _iconImage;
}

#pragma mark --- YLSContactProtocol
- (NSString *)sipName {
    return _name;
}

- (UIImage *)sipImage {
    return self.iconImage;
}

- (NSString *)sipNumber {
    return _number;
}

@end
