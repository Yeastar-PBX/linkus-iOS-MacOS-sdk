//
//  UIImage+YLS.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/21.
//

#import "UIImage+YLS.h"

@implementation UIImage (YLS)

+ (UIImage *)imageByColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:5];
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    
    [path fill];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return resultImg;
}

+ (UIImage *)imageWithText:(NSString *)name {
    
    name=[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *text = name.length > 0 ? [name.uppercaseString substringToIndex:1] : name.uppercaseString;
    
    NSDictionary *fontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:37.f weight:UIFontWeightMedium], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    CGSize textSize = [text sizeWithAttributes:fontAttributes];
    
    CGPoint drawPoint = CGPointMake((96 - textSize.width)/2, (96 - textSize.height)/2);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(96, 96), NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 96, 96) cornerRadius:4];
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRGB:0x45A5D9].CGColor);
    
    [path fill];
    
    [text drawAtPoint:drawPoint withAttributes:fontAttributes];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return resultImg;
}

@end
