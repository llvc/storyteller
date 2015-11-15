//
//  LandingPage.h
//  storyteller
//
//  Created by Alin Hila on 8/16/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingPage : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *landingSpin;
@property (nonatomic, retain) IBOutlet UITextView *subtitle;

- (IBAction) gotoLoginPage:(id)sender;

@end
