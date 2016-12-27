//
//  PereferenceService.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "PereferenceService.h"

@interface PereferenceService () {
    NSUserDefaults* userDefaults;
}
@end

@implementation PereferenceService
- (instancetype)init
{
    self = [super init];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}
-(void)saveString:(NSString*)val forKey:(NSString*) key {
    [userDefaults setObject:val forKey:key];
    [userDefaults synchronize];
}
-(NSString*) stringForKey:(NSString*) key{
    return [userDefaults stringForKey:key];
}
@end
