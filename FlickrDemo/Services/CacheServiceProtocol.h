//
//  CacheServiceProtocol.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/29/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CacheServiceProtocol <NSObject>

+(void) setSharedCacheService;

-(UIImage*) imageForName:(NSString*)name;
-(void) setImage:(UIImage*)image forName:(NSString*) name;

@end
