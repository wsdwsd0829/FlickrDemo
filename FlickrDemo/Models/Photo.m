//
//  FlickrImage.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(instancetype) initWithOriginalImageUrlString: (NSString*) ori withThumbnailImageUrlString: (NSString*) thumb withIdentifier:(NSString*) identifier {
    self = [super init];
    if (self) {
        _originalImageUrlString = ori;
        _thumbnailImageUrlString = thumb;
        _identifier = identifier;
    }
    return self;
}

@end
