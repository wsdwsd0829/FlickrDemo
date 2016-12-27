//
//  FlickrNetworkServiceProtocol.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FlickrImageListHandler)(NSArray* images, NSError* error);

@protocol FlickrNetworkServiceProtocol <NSObject>

-(void)loadImageWithUrlString: (NSString*) urlString withHandler:(void(^)(NSData* data))handler;
//recent
-(void) loadRecentImages: (FlickrImageListHandler) handler;
//interesting
-(void) loadInterestingImages: (FlickrImageListHandler) handler;
@end
