//
//  FlickrRecentImageServiceProtocol.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrNetworkServiceProtocol.h"

@protocol FlickrRecentImageServiceProtocol <NSObject, FlickrNetworkServiceProtocol>
-(void) loadRecentImages: (FlickrImageListHandler) handler;
@end
