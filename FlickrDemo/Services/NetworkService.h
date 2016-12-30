//
//  FlickrNetworkManager.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReachabilityServiceProtocol.h"

#import "NetworkServiceProtocol.h"

///Flickr service to fetch data

@interface NetworkService : NSObject <NetworkServiceProtocol, ReachabilityServiceProtocol>

//recent
-(void) loadRecentPhotos: (FlickrImageListHandler) handler;
//interesting
-(void) loadInterestingPhotos: (FlickrImageListHandler) handler;

@end
