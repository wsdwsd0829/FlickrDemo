//
//  CacheService.m
//  iOSCodingChallenge
//
//  Created by Sida Wang on 12/28/16.
//  Copyright © 2016 Touch of Modern. All rights reserved.
//

#import "CacheService.h"
@interface CacheService() {
    NSMutableDictionary* productImageCache;
}
@end
@implementation CacheService

- (instancetype)init
{
    self = [super init];
    if (self) {
        productImageCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(UIImage*) imageForName:(NSString*)name {
    return [productImageCache objectForKey: name];
}

-(void) setImage:(UIImage*)image forName:(NSString*) name {
    productImageCache[name] = image;
}

@end
