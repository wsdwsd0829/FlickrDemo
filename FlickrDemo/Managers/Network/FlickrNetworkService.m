//
//  FlickrNetworkManager.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//
#import "ApiClientProtocol.h"
#import "ParserProtocol.h"

#import "FlickrNetworkService.h"
#import "ApiClient.h"
#import "FlickrImageParser.h"
//https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20flickr.photos.interestingness%20where%20api_key%3D%27d5c7df3552b89d13fe311eb42715b510%27&diagnostics=true&format=json
//https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20flickr.photos.recent%20where%20api_key%3D%27d5c7df3552b89d13fe311eb42715b510%27&diagnostics=true&format=json
NSString* const apiKey = @"d5c7df3552b89d13fe311eb42715b510";

@interface FlickrNetworkService () {
    id<ApiClientProtocol> apiClient;
    id<ParserProtocol> parser;
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

-(void)loadImageWithUrlString: (NSString*) urlString withHandler:(void(^)(NSData* data))handler{
    //GCD or Operation
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: urlString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(imageData);
        });
    });
}

-(void) loadRecentImages: (FlickrImageListHandler)handler {
   // NSLog(@"Recent Images Page Num: %lu", (unsigned long)pageNum);
    NSUInteger offset = pageCount * pageNum;
    NSString* query = [NSString stringWithFormat:@"select * from flickr.photos.recent(%ld,%ld) where api_key='%@'", (long)offset, (long)pageCount, apiKey];
    NSDictionary* params = @{@"q" : query, @"diagnostics": @"true", @"format": @"json"};
    NSLog(@"QUERY: %@", query); //QUERY: select * from flickr.photos.recent(40,20) where api_key='d5c7df3552b89d13fe311eb42715b510'
    [self p_fetchWithParams:params withHandler:handler];
}

-(void) loadInterestingImages: (FlickrImageListHandler) handler {
   // NSLog(@"Interesting Images Page Num: %lu", (unsigned long)pageNum);
    NSUInteger offset = pageCount * pageNum;
    NSString* query = [NSString stringWithFormat:@"select * from flickr.photos.interestingness(%ld,%ld) where api_key='%@'", (long)offset, (long)pageCount, apiKey];
    
    NSDictionary* params = @{@"q" : query, @"diagnostics": @"true", @"format": @"json"};
    [self p_fetchWithParams:params withHandler:handler];
}

//private method that use apiClient to fetch Data and use parser to get object (can pare async)
-(void) p_fetchWithParams: (NSDictionary*) params withHandler:(FlickrImageListHandler) handler {
    pageNum += 1; //how to deal wich if previous page load fails
    [apiClient fetchWithParams:params withApi: @"v1/public/yql" withHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error && ((NSHTTPURLResponse*)response).statusCode == 200) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Parse result in background thread
                [parser parseToFlickrImagesWith:responseObject withHandler: ^(NSArray* images, NSError* error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        handler(images, error);
                    });
                    //!!!cannot increase page num here cause, same page may load multiple times
                }];
            });
           
        } else {
            // if status Code 401, need re-auth;
            handler(nil, error);
        }
    }];
}

@end
