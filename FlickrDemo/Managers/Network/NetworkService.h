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

@interface NetworkService : NSObject <FlickrNetworkServiceProtocol>

//load image
-(void)loadImageWithUrlString: (NSString*) urlString withHandler:(void(^)(NSData* data))handler;
-(void)loadPhotosWithType: (ImageListType)type withHandler:(FlickrImageListHandler) handler;

//recent
-(void) loadRecentPhotos: (FlickrImageListHandler) handler;
//interesting
-(void) loadInterestingPhotos: (FlickrImageListHandler) handler;

@end
