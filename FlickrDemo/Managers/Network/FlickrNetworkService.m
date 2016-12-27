//
//  FlickrNetworkManager.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "FlickrNetworkService.h"
#import "ApiClientProtocol.h"
#import "ApiClient.h"

#import "FlickrImageParser.h"
//https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20flickr.photos.interestingness%20where%20api_key%3D%27d5c7df3552b89d13fe311eb42715b510%27&diagnostics=true&format=json
//https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20flickr.photos.recent%20where%20api_key%3D%27d5c7df3552b89d13fe311eb42715b510%27&diagnostics=true&format=json

@interface FlickrNetworkService () {
    id<ApiClientProtocol> apiClient;
    FlickrImageParser* parser;
    NSUInteger pageNum;
    NSUInteger pageCount;
}

@end
@implementation FlickrNetworkService

- (instancetype)init
{
    self = [super init];
    if (self) {
        apiClient = [ApiClient defaultClient];
        parser = [[FlickrImageParser alloc] init]; //? can this be singeton, can I just use static method to parse data
        pageNum = 0;
        pageCount = 20;
    }
    return self;
}

-(void) loadRecentImages: (FlickrImageListHandler)handler {
    NSUInteger offset = pageCount * pageNum;
    NSString* query = [NSString stringWithFormat:@"select * from flickr.photos.recent(%ld,%ld) where api_key='d5c7df3552b89d13fe311eb42715b510'", (long)offset, (long)pageCount];
    NSDictionary* params = @{@"q" : query, @"diagnostics": @"true", @"format": @"json"};
    [self p_fetchWithParams:params withHandler:handler];
}

-(void) loadInterestingImages: (FlickrImageListHandler) handler {
    NSUInteger offset = pageCount * pageNum;
    NSString* query = [NSString stringWithFormat:@"select * from flickr.photos.interestingness(%ld,%ld) where api_key='d5c7df3552b89d13fe311eb42715b510'", (long)offset, (long)pageCount];
    NSDictionary* params = @{@"q" : query, @"diagnostics": @"true", @"format": @"json"};
    [self p_fetchWithParams:params withHandler:handler];
}

//private method that use apiClient to fetch Data and use parser to get object (can pare async)
-(void) p_fetchWithParams: (NSDictionary*) params withHandler:(FlickrImageListHandler) handler {
    [apiClient fetchWithParams:params withApi: @"v1/public/yql" withHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error && ((NSHTTPURLResponse*)response).statusCode == 200) {
            [parser parseToFlickrImagesWith:responseObject withHandler: ^(NSArray* images, NSError* error) {
                handler(images, error);
                if(error == nil) {
                    pageNum += 1;
                }
            }];
        } else {
            //TODO: if status Code 401, need re-auth;
            handler(nil, error);
        }
    }];
}

@end
