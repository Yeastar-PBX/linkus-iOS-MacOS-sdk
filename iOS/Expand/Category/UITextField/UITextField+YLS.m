//
//  UITextField+YLS.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/21.
//

#import "UITextField+YLS.h"

@implementation UITextField (YLS)

- (void)ys_updateText:(NSString *)text {
    UITextPosition *beginning = self.beginningOfDocument;//文字的开始地方
    UITextPosition *startPosition = self.selectedTextRange.start;//光标开始位置
    UITextPosition *endPosition = self.selectedTextRange.end;//光标结束位置
    NSInteger startIndex = [self offsetFromPosition:beginning toPosition:startPosition];//获取光标开始位置在文字中所在的index
    NSInteger endIndex = [self offsetFromPosition:beginning toPosition:endPosition];//获取光标结束位置在文字中所在的index
    
    // 将输入框中的文字分成两部分，生成新字符串，判断新字符串是否满足要求
    NSString *originText = self.text;
    NSString *beforeString = [originText substringToIndex:startIndex];//从起始位置到当前index
    NSString *afterString = [originText substringFromIndex:endIndex];//从光标结束位置到末尾
    
    NSInteger offset;
    
    if (![text isEqualToString:@""]) {
        offset = text.length;
    }
    else {
        // 只删除一个字符
        if (startIndex == endIndex) {
            if (startIndex == 0) {
                return;
            }
            offset = -1;
            beforeString = [beforeString substringToIndex:(beforeString.length - 1)];
        } else {
            //光标选中多个
            offset = 0;
        }
    }
    
    NSString *newText = [NSString stringWithFormat:@"%@%@%@", beforeString, text, afterString];
    self.text = newText;
    
    UITextPosition *nowPosition = [self positionFromPosition:startPosition offset:offset];
    UITextRange *range = [self textRangeFromPosition:nowPosition toPosition:nowPosition];
    self.selectedTextRange = range;
}

-(NSRange)ys_selectedRange{
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    NSInteger length = [self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end];
    return NSMakeRange(location, length);
}

-(void)setYs_selectedRange:(NSRange)selectedRange{
    UITextPosition *startPosition = [self positionFromPosition:self.beginningOfDocument offset:selectedRange.location];
    UITextPosition *endPosition = [self positionFromPosition:self.beginningOfDocument offset:selectedRange.location + selectedRange.length];
    UITextRange *selectedTextRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectedTextRange];
}

@end
