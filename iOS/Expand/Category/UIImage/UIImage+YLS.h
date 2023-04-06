//
//  UIImage+YLS.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/21.
//

#import <UIKit/UIKit.h>

@interface UIImage (YLS)

+ (UIImage *)imageByColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithText:(NSString *)name;

@end
