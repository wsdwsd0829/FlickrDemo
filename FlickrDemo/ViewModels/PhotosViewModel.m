//
//  PhotosViewModel.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//
//services

//#import "FlickrRecentImageServiceProtocol.h"
//#import "FlickrInterestingImageServiceProtocol.h"


#import "PhotosViewModel.h"
#import "FlickrNetworkService.h"
#import "MessageManager.h"
#import "PereferenceService.h"
@interface PhotosViewModel() {
    //private backing stores
    NSMutableArray<FlickrImage*>* recentImages;
    NSMutableArray<FlickrImage*>* interestingImages;
    id<FlickrNetworkServiceProtocol> recentImagesService;
    id<FlickrNetworkServiceProtocol> interestingImageService;
    
    //for ui
    id<FlickrNetworkServiceProtocol> imageService;
    NSArray<FlickrImage*>* _images;
    
    //callback handling
    id<MessageManagerProtocol> messageManager;
    id<PersistenceProtocol> persistenceService;
    
}
@end

@implementation PhotosViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        //setup services
        recentImages = [NSMutableArray new];
        interestingImages = [NSMutableArray new];
        recentImagesService = [[FlickrNetworkService alloc] init];
        interestingImageService = [[FlickrNetworkService alloc] init];
        
        // actual services
        imageService = recentImagesService;
        _images = recentImages;
        
        messageManager = [[MessageManager alloc] init];
        persistenceService = [[PereferenceService alloc] init];
        [self setupSegmentControl];
    }
    return self;
}

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

- (void)segmentedControlChanged:(ImageListType)type {
    self.type = type;
    switch(type){
        case ImageListTypeRecent:
            imageService = recentImagesService;
            _images = recentImages;
            [persistenceService saveString: kUserDefaultsImageListRecent forKey:kUserDefaultsImagePreference];
            break;
        case ImageListTypeInteresting:
            imageService = interestingImageService;
            _images = interestingImages;
            [persistenceService saveString:kUserDefaultsImageListInteresting forKey:kUserDefaultsImagePreference];
            break;
    }
    //update ui
    self.updateBlock();
}

-(void) loadImages {
    if(imageService == recentImagesService) {
        [imageService loadRecentImages:^(NSArray *imgs, NSError *error) {
            if(!error) {
                if(imgs.count > 0) {
                    [recentImages addObjectsFromArray:imgs];
                    self.updateBlock();
                }
            } else {
                [self p_handleError: error];
            }
        }];
    } else {
        [imageService loadInterestingImages:^(NSArray *imgs, NSError *error) {
            if(!error) {
                if(imgs.count > 0) {
                    [interestingImages addObjectsFromArray:imgs];
                    self.updateBlock();
                }
            } else {
                [self p_handleError: error];
            }
        }];
    }
}

-(void)loadImageForIndexPath:(NSIndexPath*)indexPath withHandler:(void(^)())handler {
    //!!! need capture imageService so it not change in block
    id<FlickrNetworkServiceProtocol> imageDownloadService = imageService;
    NSString* urlString = self.images[indexPath.row].originalImageUrlString;
    [imageDownloadService loadImageWithUrlString:urlString withHandler:^(NSData *data) {
        if(imageDownloadService == recentImagesService) {
            if(!recentImages[indexPath.row].image) {
                recentImages[indexPath.row].image = [UIImage imageWithData:data];
                handler();
                //!!! do not save image twice, and do not update image multiple times
            }
        } else {
            if(!interestingImages[indexPath.row].image) {
                interestingImages[indexPath.row].image = [UIImage imageWithData:data];
                handler();
            }
        }
        
    }];
}

//to initialize loading;
-(void) p_initializeLoading{
    [recentImagesService loadRecentImages:^(NSArray *imgs, NSError *error) {
        if(!error) {
            if(imgs.count > 0) {
                [recentImages addObjectsFromArray:imgs];
                self.updateBlock();
            }
        } else {
            [self p_handleError: error];
        }
    }];
    
    [interestingImageService loadInterestingImages:^(NSArray *imgs, NSError *error) {
        if(!error) {
            if(imgs.count > 0) {
                [interestingImages addObjectsFromArray:imgs];
                self.updateBlock();
            }
        } else {
            [self p_handleError: error];
        }
    }];
}

-(void) p_handleError:(NSError*)error {
    [messageManager showError:error];
}

@end
