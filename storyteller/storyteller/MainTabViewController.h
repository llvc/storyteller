//
//  MainTabViewController.h
//  storyteller
//
//  Created by Alin Hila on 8/17/15.
//  Copyright (c) 2015 niklas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabViewController : UITabBarController

- (IBAction)backToLoginPage:(id)sender;
- (void) setTabbarItemStatus;
- (void) setTabbarItemImage;

@end
