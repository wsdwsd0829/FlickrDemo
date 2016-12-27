//
//  MessageManagerProtocol.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessageManagerProtocol <NSObject>
-(void)showError:(NSError*) error;

@end
