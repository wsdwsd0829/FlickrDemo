//
//  MessageManager.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "MessageManager.h"
#import "AppDelegate.h"
#import "DemoConstants.h"
#import "UIViewController+Navigations.h"
#import <UIKit/UIKit.h>
@implementation MessageManager

-(void)showError:(NSError*) error {
    
   UIViewController* vc = [((AppDelegate*)[[UIApplication sharedApplication] delegate]).window.rootViewController topVisibleViewController];
    
    if([vc isKindOfClass:[UIAlertController class]]) {
        return;
    }
    
    NSString* message = [error.userInfo objectForKey: kErrorDisplayUserInfoKey];
    if(!message) {
        message = [error localizedDescription];
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Error Occured" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alertVC addAction:defaultAction];
    [vc presentViewController:alertVC animated:YES completion:nil];
    
}

@end
