//
//  Utils.m
//  kitchenoc
//
//  Created by sidawang on 8/24/15.
//  Copyright (c) 2015 admax. All rights reserved.
//

#import "Utils.h"
#import <sys/utsname.h>

@interface Utils()
@end

@implementation Utils
-(NSString*)upcase:(NSString *)str{
    return [str uppercaseString];
}

-(void) dispatchAfter: (NSInteger)second withHandler:(void(^)()) handler {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, second * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        handler();
    });
}
#pragma mark - coding related
+(NSString *)base64encoder:(NSString *)str{
    NSData* utf8data= [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64Encoded = nil;
    if(utf8data != nil){
        if ([utf8data respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
            base64Encoded = [utf8data base64EncodedStringWithOptions:kNilOptions];
        }else{
            // base64Encoded = [utf8data base64Encoding]; //for ios prior to 7.0
        }
     }
    return base64Encoded;
}
+(NSString *)base64decoder:(NSString *)str{
    NSString* base64Decoded = nil;
    NSData* data =  nil;
    if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
        data = [[NSData alloc] initWithBase64EncodedString:str options:kNilOptions];
    }else{
        //data = [[NSData alloc] initWithBase64Encoding:str]; //for ios prior to 7.0
    }
    if(data != nil){
        base64Decoded = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return base64Decoded;
}
+(NSString*)urlEncode: (NSString*)str{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 kCFAllocatorDefault,
                                                                                 (__bridge CFStringRef)str,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}
+(NSString*) urlDecode:(NSString*) str {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                                 kCFAllocatorDefault,
                                                                                                 (__bridge CFStringRef)str,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}
@end
