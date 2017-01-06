//
//  CacheService.m
//  iOSCodingChallenge
//
//  Created by Sida Wang on 12/28/16.
//  Copyright © 2016 Touch of Modern. All rights reserved.
//

#import "CacheService.h"
/*
 ??? on simulator
 netcore_create_control_socket socket(PF_SYSTEM, SOCK_DGRAM, SYSPROTO_CONTROL) failed: [24] Too many open files, dumping backtrace:
 */

@interface CacheService() {
    NSMutableDictionary* productImageCache;
    //NSCache* productImageCache;
}
@end
@implementation CacheService

//this will set NSURLCache globally and work with nsurlsession
+(void) setSharedCacheService {
    NSURLCache* urlCache = [[NSURLCache alloc] initWithMemoryCapacity:40*1024*1024 diskCapacity:100*1024*1024 diskPath:@"diskpath"];
    [NSURLCache setSharedURLCache:urlCache];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        productImageCache = [[NSMutableDictionary alloc] init]; // [[NSCache alloc] init]; // //
    }
    return self;
}

-(UIImage*) imageForName:(NSString*)name {
    return [productImageCache objectForKey: name];
}

-(void) setImage:(UIImage*)image forName:(NSString*) name {
    if(name != nil) {
        [productImageCache setObject:image forKey:name];
    }
}

-(void)cleanUp {
    productImageCache = [[NSMutableDictionary alloc] init];
}
@end
