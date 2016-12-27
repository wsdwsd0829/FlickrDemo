//
//  FlickrNetworkManager.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlickrNetworkServiceProtocol.h"
#import "ApiClientProtocol.h"
#import "ApiClient.h"
#import "FlickrImageParser.h"

///Flickr service to fetch data

@interface FlickrNetworkService : NSObject <FlickrNetworkServiceProtocol>{
    id<ApiClientProtocol> apiClient;
    FlickrImageParser* parser;
    NSUInteger pageNum;
    NSUInteger pageCount;
}
-(void) p_fetchWithParams: (NSDictionary*) params withHandler:(FlickrImageListHandler) handler;
//recent
-(void) loadRecentImages: (FlickrImageListHandler) handler;
//interesting
-(void) loadInterestingImages: (FlickrImageListHandler) handler;

@end
