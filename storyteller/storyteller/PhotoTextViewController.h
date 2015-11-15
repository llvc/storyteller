//
//  PhotoTextViewController.h
//  storyteller
//
//  Created by Alin Hila on 8/27/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MCPlaceholderTextView.h"
#import "Config.h"

@interface PhotoTextViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *myPathDocs;
@property (nonatomic, retain) Question *question;

@property (nonatomic, retain) MCPlaceholderTextView *responseTextView;
@property (nonatomic, retain) UIView *textViewContainer;
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;

@property (nonatomic, retain) IBOutlet UIImageView *photoView;

-(UIImage*) drawText:(NSString*) text inImage:(UIImage*) image atPoint:(CGPoint) point;

- (IBAction) popThisView;
- (IBAction) submitThisResponse:(id)sender;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillDisappear:(NSNotification *)notification;

- (BOOL)isAcceptableTextLength:(NSUInteger)length;
    
@end
