//
//  MCPlaceholderTextView.h
//  MCChat
//
//  Created by BYJ on 1/26/15.
//  Copyright (c) 2015 PY Office. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCPlaceholderTextView : UITextView

@property (strong, nonatomic) NSString *placeholder;

- (void)updateShouldDrawPlaceholder;

@end
