//
//  PhotosViewModel.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

//Services
#import "MessageManager.h"
#import "PereferenceService.h"
#import "NetworkService.h"

//ViewModels
#import "PhotosViewModel.h"

@interface PhotosViewModel() {
    //private backing stores
    //for ui
    NSMutableArray<Photo*>* _photos;
    id<FlickrNetworkServiceProtocol> networkService;
    
    id<MessageManagerProtocol> messageManager;
    id<PersistenceProtocol> persistenceService;
}

@end

@implementation PhotosViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSException exceptionWithName:@"Wrong usage" reason:@"Must provide a type of image to load using initWithType:" userInfo:nil] raise];
        
    }
    return self;
}

- (instancetype)initWithType: (ImageListType) type
{
    self = [super init];
    if (self) {
        self.type = type;
        _photos = [NSMutableArray new];
        
        //setup services
        networkService = [[NetworkService alloc] init];
        messageManager = [[MessageManager alloc] init];  //TODO: ? sharedMessageManager
        persistenceService = [[PereferenceService alloc] init];
        self.cacheService = [[CacheService alloc] init];
        
    }
    return self;
}

/*
-(void)setupSegmentControl {
    NSString* imageListPref = [persistenceService stringForKey:kUserDefaultsImagePreference];
    if(!imageListPref || [imageListPref isEqualToString:kUserDefaultsImageListRecent]) {
        imageService = recentImagesService;
        _images = recentImages;
        self.type = ImageListTypeRecent;
    } else if([imageListPref isEqualToString:kUserDefaultsImageListInteresting]){
        imageService = interestingImageService;
        _images = interestingImages;
        self.type = ImageListTypeInteresting;
    }
    [self updateBlock]; //update type in time
    [self p_initializeLoading];
}
 */

- (void)segmentedControlChanged:(ImageListType)type {
    self.type = type;
    switch(type){
        case ImageListTypeRecent:
            [persistenceService saveString: kUserDefaultsImageListRecent forKey:kUserDefaultsImagePreference];
            break;
        case ImageListTypeInteresting:
            [persistenceService saveString:kUserDefaultsImageListInteresting forKey:kUserDefaultsImagePreference];
            break;
    }
    //update ui
    self.updateBlock();
}

-(Photo*)previousPhotoFor:(Photo *)photo {
    NSInteger index = [self.photos indexOfObject: photo];
    if(index == 0) {
        return nil;
    }
    return self.photos[index - 1];
}

-(Photo*)nextPhotoFor:(Photo *)photo {
    NSInteger index = [self.photos indexOfObject: photo];
    if(index + 10 > self.photos.count) {
        [self loadImages];
    }
    if(index == self.photos.count-1) {
        return nil;
    }
   return self.photos[index + 1];
}

-(void) loadImages {
    [networkService loadPhotosWithType:self.type withHandler:^(NSArray *imgs, NSError *error) {
        if(!error) {
            if(imgs.count > 0) {
                [_photos addObjectsFromArray:imgs];
                self.updateBlock();
            }
        } else {
            [self p_handleError: error];
        }
    }];
}

-(void)loadImageForIndexPath:(NSIndexPath*)indexPath withHandler:(void(^)(UIImage* image))handler {
    //!!! need capture imageService so it not change in block
    NSString* urlString = self.photos[indexPath.row].originalImageUrlString;
    UIImage* img = [self.cacheService imageForName:urlString];
    if(!img) {
        [networkService loadImageWithUrlString: urlString withHandler:^(NSData *data) {
            UIImage* newImage = [UIImage imageWithData:data];
            [self.cacheService setImage: newImage forName:urlString];
            handler(newImage);
        }];
    } else {
        handler(img);
    }
}
-(void)loadImageWithUrlString: urlString withHandler:(void(^)(UIImage* image))handler  {
    UIImage* img = [self.cacheService imageForName:urlString];
    if(img) {
        handler(img);
        return;
    }
    [networkService loadImageWithUrlString: urlString withHandler:^(NSData *data) {
        if(data) {
            UIImage* newImage = [UIImage imageWithData:data];
            if(newImage) {
                handler(newImage);
            }
            if(urlString != nil){
                [self.cacheService setImage: newImage forName:urlString];
            }
        }
    }];
}

-(void) p_handleError:(NSError*)error {
    [messageManager showError:error];
}

@end
