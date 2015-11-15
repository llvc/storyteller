//
//  UserNameTextField.m
//  storyteller
//
//  Created by Alin Hila on 8/16/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserNameTextField.h"

@interface UserNameTextField()

@end

@implementation UserNameTextField

- (void)drawPlaceholderInRect:(CGRect)rect
{
    UIColor *colour = [UIColor whiteColor];
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.alignment = NSTextAlignmentCenter;
    
    if ([self.placeholder respondsToSelector:@selector(drawInRect:withAttributes:)]) {
        // iOS7 and later
        NSDictionary *attributes = @{NSForegroundColorAttributeName: colour, NSFontAttributeName: self.font};
        CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
        self.textAlignment = NSTextAlignmentCenter;
        [self.placeholder drawAtPoint:CGPointMake((rect.size.width/2)-boundingRect.size.width/2, (rect.size.height/2)-boundingRect.size.height/2) withAttributes:attributes];
    }
    else {
        // iOS 6
        [colour setFill];
//        - (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment NS_DEPRECATED_IOS(2_0, 7_0, "Use -drawInRect:withAttributes:");
        [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
    }
}

@end