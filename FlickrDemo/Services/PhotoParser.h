//
//  PhotoParser.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserProtocol.h"
@interface PhotoParser : NSObject<ParserProtocol>
-(void)parseToPhotosWith: (id) responseObject withHandler: (void(^)(NSArray* photos, NSError* error)) handler;
@end
