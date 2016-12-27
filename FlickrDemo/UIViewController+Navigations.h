//
//  UIViewController+Navigations.h
//  ViewControllerNavigation
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Navigations)
///return if current controller or it's parent is presented modally before. not necessarily presented by parent
-(BOOL)isModal;
///controller that should be on screen
-(UIViewController*) topVisibleViewController;
///remove current controller only while try to keep all parent/presenting in structure.
-(void)removeMyself;

@end
