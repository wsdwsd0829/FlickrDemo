//
//  PhotoParser.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "PhotoParser.h"
#import "Photo.h"

@implementation PhotoParser

-(void)parse:(id)responseObject withHandler:(void (^)(NSArray *, NSError *))handler {
    [self parseToPhotosWith:responseObject withHandler:handler];
}

-(void)parseToPhotosWith: (id) responseObject withHandler: (void(^)(NSArray* photos, NSError* error)) handler {
    NSMutableArray* photos = [NSMutableArray new];
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
            NSArray* objs = dict[@"query"][@"results"][@"photo"];
            for(id photo in objs) {
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
                            NSString* identity = [NSString stringWithFormat:@"%@_%@_%@_%@", farm, identifier, secret, server];
                            
                            NSString* title;
                            if([photoDict objectForKey: @"title"]) {
                                title = photoDict[@"title"];
                            }
                            
                            Photo* newPhoto = [[Photo alloc] initWithOriginalImageUrlString:orginalUrlStr withThumbnailImageUrlString:thumbnailUrlStr withIdentifier:identity];
                            
                            newPhoto.title = title;
                            [photos addObject:newPhoto];
                        }
                    }
                }
            }
        }
    }
    
    if(photos.count > 0) {
        handler(photos, nil);
    } else {
        NSError* err = [NSError errorWithDomain:@"FlickrImageParseError" code:1000 userInfo: @{@"display": @"Fail to parse images"}];
        handler(nil, err);
        
    }
}
@end
