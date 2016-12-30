//
//  PhotosViewModel.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"
#import "CacheService.h"

@interface PhotosViewModel : NSObject

@property (nonatomic, readonly) NSArray<Photo*>* photos;
@property (nonatomic, copy) void(^updateBlock)();
@property (nonatomic) ImageListType type;

@property id<CacheServiceProtocol> cacheService;

- (instancetype)initWithType: (ImageListType) type;

- (void)segmentedControlChangedTo:(ImageListType)type;
-(void) loadImages;
-(void)loadImageForIndexPath:(NSIndexPath*)indexPath withHandler:(void(^)(UIImage* image))handler;
-(void)loadImageWithUrlString: urlString withHandler:(void(^)(UIImage* image))handler;

-(Photo*) nextPhotoFor: (Photo*) photo;
-(Photo*) previousPhotoFor:(Photo*)photo;
@end

