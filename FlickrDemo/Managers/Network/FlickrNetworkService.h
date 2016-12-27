//
//  FlickrNetworkManager.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlickrNetworkServiceProtocol.h"

///Flickr service to fetch data

@interface FlickrNetworkService : NSObject <FlickrNetworkServiceProtocol>

//recent
-(void) loadRecentImages: (FlickrImageListHandler) handler;
//interesting
-(void) loadInterestingImages: (FlickrImageListHandler) handler;

@end
