//
//  ParserProtocol.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserProtocol <NSObject>

-(void)parseToFlickrImagesWith: (id) responseObject withHandler: (void(^)(NSArray* images, NSError* error)) handler;

@end
