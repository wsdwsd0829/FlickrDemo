//
//  FlickrNetworkManager.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//
#import "ApiClientProtocol.h"
#import "ParserProtocol.h"
#import "Reachability.h"
#import "NetworkService.h"
#import "ApiClient.h"
#import "PhotoParser.h"
//https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20flickr.photos.interestingness%20where%20api_key%3D%27d5c7df3552b89d13fe311eb42715b510%27&diagnostics=true&format=json
//https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20flickr.photos.recent%20where%20api_key%3D%27d5c7df3552b89d13fe311eb42715b510%27&diagnostics=true&format=json
NSString* const apiKey = @"d5c7df3552b89d13fe311eb42715b510";

@interface NetworkService () {
    id<ApiClientProtocol> apiClient;
    id<ParserProtocol> parser;
    Reachability* reachability;

    NSUInteger pageNum;
    NSUInteger pageCount;
}

@end
@implementation NetworkService

- (instancetype)init
{
    self = [super init];
    if (self) {
        apiClient = [ApiClient defaultClient];
        parser = [[PhotoParser alloc] init]; //? can this be singeton, can I just use static method to parse data
        
        //setup reachability
        reachability = [Reachability reachabilityForInternetConnection];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
        [reachability startNotifier];
        
        pageNum = 0;
        pageCount = 20;
    }
    return self;
}

-(void)loadImageWithUrlString: (NSString*) urlString withHandler:(void(^)(NSData* data, NSError* error))handler{
    //GCD or Operation
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: urlString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(imageData);
        });
    });
     */
    [apiClient fetchWithUrlString:urlString withHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        handler(responseObject, error);
    }];
}

-(void)loadPhotosWithType:(ImageListType)type withHandler:(FlickrImageListHandler)handler {
    switch (type) {
        case ImageListTypeRecent:
            [self loadRecentPhotos:handler];
            break;
        case ImageListTypeInteresting:
            [self loadInterestingPhotos:handler];
            break;
    }
}

-(void) loadRecentPhotos: (FlickrImageListHandler)handler {
   // NSLog(@"Recent Images Page Num: %lu", (unsigned long)pageNum);
    NSUInteger offset = pageCount * pageNum;
    NSString* query = [NSString stringWithFormat:@"select * from flickr.photos.recent(%ld,%ld) where api_key='%@'", (long)offset, (long)pageCount, apiKey];
    NSDictionary* params = @{@"q" : query, @"diagnostics": @"true", @"format": @"json"};
    NSLog(@"QUERY: %@", query); //QUERY: select * from flickr.photos.recent(40,20) where api_key='d5c7df3552b89d13fe311eb42715b510'
    [self p_fetchWithParams:params withHandler:handler];
}

-(void) loadInterestingPhotos: (FlickrImageListHandler) handler {
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
                [parser parse:responseObject withHandler: ^(NSArray* images, NSError* error) {
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

//Mark: Reachability Protocol
-(void)networkChanged:(NSNotification*) notification {
    Reachability* reach = notification.object;
    if([reach currentReachabilityStatus] == ReachableViaWiFi || [reach currentReachabilityStatus] == ReachableViaWWAN) {
        NSString* isFromNotReachable = [[NSUserDefaults standardUserDefaults] stringForKey:@"kNotReachable"];
        if([isFromNotReachable isEqualToString:@"YES"]) {
            [self networkChangedFromOfflineToOnline:notification];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"kNotReachable"];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"kNotReachable"];
    }
}
-(void)networkChangedFromOfflineToOnline:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkOfflineToOnline object: notification.object];
}

-(void)dealloc {
    [reachability stopNotifier];
}
@end
