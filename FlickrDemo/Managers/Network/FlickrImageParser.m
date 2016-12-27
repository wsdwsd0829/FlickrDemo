//
//  FlickrImageParser.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "FlickrImageParser.h"
#import "FlickrImage.h"

@implementation FlickrImageParser

-(void)parseToFlickrImagesWith: (id) responseObject withHandler: (void(^)(NSArray* images, NSError* error)) handler {
    NSMutableArray* images = [NSMutableArray new];
    if([responseObject isKindOfClass: [NSDictionary class]]) {
        NSDictionary* dict = (NSDictionary*) responseObject;
        int count = 0;
        if([dict objectForKey:@"query"] && [dict[@"query"] objectForKey:@"count"]) {
            count = [dict[@"query"][@"count"] intValue];
        } else {
            NSError* err = [NSError errorWithDomain:@"FlickrImageParseError" code:1001 userInfo: @{@"display": @"No more images"}];
            handler(nil, err);
            return;
        }
        if(count > 0 && [dict[@"query"] objectForKey: @"results"] && [dict[@"query"][@"results"] objectForKey:@"photo"]) {
            NSArray* photos = dict[@"query"][@"results"][@"photo"];
            for(id photo in photos) {
                @autoreleasepool {
                    if([photo isKindOfClass:[NSDictionary class]]) {
                        NSDictionary* photoDict = (NSDictionary*) photo;
                        NSString* farm = photoDict[@"farm"];
                        NSString* identifier = photoDict[@"id"];
                        NSString* secret = photoDict[@"secret"];
                        NSString* server = photoDict[@"server"];
                        if(farm && identifier && secret && server) {
                            NSString* orginalUrlStr = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", farm, server, identifier, secret];
                            NSString* thumbnailUrlStr = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_t_d.jpg", farm, server, identifier, secret];
                            FlickrImage* image = [[FlickrImage alloc] initWithOriginalImageUrlString:orginalUrlStr withThumbnailImageUrlString:thumbnailUrlStr];
                            [images addObject:image];
                        }
                    }
                }
            }
        }
    }
    
    if(images.count > 0) {
        handler(images, nil);
    } else {
        NSError* err = [NSError errorWithDomain:@"FlickrImageParseError" code:1000 userInfo: @{@"display": @"Fail to parse images"}];
        handler(nil, err);
        
    }
}
@end
