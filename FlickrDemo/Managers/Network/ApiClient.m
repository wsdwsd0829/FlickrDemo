//
//  ApiClient.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "ApiClient.h"
#import "Utils.h"
#import <AFNetworking/AFNetworking.h>

NSString* const hostURL = @"https://query.yahooapis.com/";
typedef NS_ENUM(NSUInteger, RequestMethod) {
    GET, POST_JSON, POST_FORM
};

@implementation ApiClient
//method, domain, api, //params dict for get, //post serialization
+(instancetype) defaultClient {
    static dispatch_once_t onceToken;
    static ApiClient* apiClient;
    dispatch_once(&onceToken, ^{
        apiClient = [[ApiClient alloc] init];
    });
    return apiClient;
}

-(void) fetchWithParams:(NSDictionary*) params withApi: (NSString*)api withHandler:(HttpResponseHandler) handler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString* hostApi = [self p_hostApiStringWithHost:hostURL withApi:api];
    NSURLRequest* request = [self p_requestSerializerWithMethod: GET host: hostApi params: params error: nil];
                                    
//    NSURL *URL = [NSURL URLWithString:[self p_queryStringFromParams: params]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //TODO create DataTask provide to abstract AFNetworking away;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        handler(response, responseObject, error);
    }];
    [dataTask resume];
}

-(void) postFormWithParams: (NSDictionary*) params withApi: (NSString*)api withHandler: (HttpResponseHandler) handler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString* hostApi = [self p_hostApiStringWithHost:hostURL withApi:api];

    NSURLRequest* request = [self p_requestSerializerWithMethod: POST_FORM host: hostApi params: params error: nil];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        handler(response, responseObject, error);
    }];                                    [dataTask resume];
}

-(void) postJSONWithParams: (NSDictionary*) params withApi: (NSString*)api withHandler: (HttpResponseHandler) handler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString* hostApi = [self p_hostApiStringWithHost:hostURL withApi:api];
    NSURLRequest* request = [self p_requestSerializerWithMethod: POST_JSON host: hostApi params: params error: nil];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        handler(response, responseObject, error);
    }];
    [dataTask resume];
}

-(NSString*) p_hostApiStringWithHost: (NSString*)host withApi:(NSString*) api {
    NSString* hostApi = [NSString stringWithFormat:@"%@%@", host, api];
    return hostApi;
}

-(NSMutableURLRequest*) p_requestSerializerWithMethod: (RequestMethod) requestMethod host: (NSString*)urlString params: (NSDictionary*)params error: (NSError**) error {
    NSMutableURLRequest* request;
    switch(requestMethod) {
        case GET:
            request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:params error: error];
            break;
        case POST_FORM:
            request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
            break;
        case POST_JSON:
            request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:params error:nil];
            break;
    }
    return request;
}

//not used for AFNetworking can handle them in serialiser
-(NSString*)p_queryStringFromParams: (NSDictionary*) params {
    NSString* paramsString = [self p_stringFromParams: params];
    return [NSString stringWithFormat:@"%@?%@", hostURL, paramsString];
}

-(NSString*)p_stringFromParams: (NSDictionary*) params {
    NSMutableArray* paramsResults = [NSMutableArray new];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableString* temp = [NSMutableString stringWithString:@""];
        [temp appendString:key];
        [temp appendString:@"="];
        //TODO escape obj
        [temp appendString: [Utils urlEncode:obj]];
        [paramsResults addObject:temp];
    }];
    return [NSString stringWithFormat:@"%@", [paramsResults componentsJoinedByString:@"&"]];
}
@end
