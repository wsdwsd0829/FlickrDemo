//
//  FlickrImageParser.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserProtocol.h"
@interface FlickrImageParser : NSObject<ParserProtocol>
-(void)parseToFlickrImagesWith: (id) responseObject withHandler: (void(^)(NSArray* images, NSError* error)) handler;
@end
