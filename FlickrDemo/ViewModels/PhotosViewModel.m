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
    id<NetworkServiceProtocol> networkService;
    
    id<MessageManagerProtocol> messageManager;
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
        self.cacheService = [[CacheService alloc] init];
        
    }
    return self;
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
    [networkService loadPhotosWithType:self.type withHandler:^(NSArray *imgs, NSError* error) {
        if(!error) {
            if(imgs.count > 0) {
                [_photos addObjectsFromArray:imgs];
                self.updateBlock();
            }
        } else {
            NSLog(@"loadImages error: %@", error);
            [self p_handleError: error];
        }
    }];
}

-(void)loadImageForIndexPath:(NSIndexPath*)indexPath withHandler:(void(^)(UIImage* image))handler {
    NSString* urlString = self.photos[indexPath.row].originalImageUrlString;
    UIImage* img = [self.cacheService imageForName:urlString];
    if(!img) {
        [networkService loadImageWithUrlString: urlString withHandler:^(NSData *data, NSError* error) {
            if(error) {
                NSLog(@"loadImageForIndexPath error: %@", error);
                [self p_handleError:error];
                return;
            }
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
    [networkService loadImageWithUrlString: urlString withHandler:^(NSData *data, NSError* error) {
        if(error) {
            NSLog(@"loadImageWithUrlString error: %@", error);
            [self p_handleError:error];
            return;
        }
        if(data) {
            UIImage* newImage = [UIImage imageWithData:data];
            if(newImage) {
                handler(newImage);
                [self.cacheService setImage: newImage forName:urlString];
            }
        }
    }];
}

-(void) p_handleError:(NSError*)error {
    [messageManager showError:error];
}

@end
