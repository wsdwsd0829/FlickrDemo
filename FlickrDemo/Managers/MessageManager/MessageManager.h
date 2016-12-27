//
//  MessageManager.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageManagerProtocol.h"
//handle in app messages, errors, etc.
@interface MessageManager : NSObject<MessageManagerProtocol>
@end
