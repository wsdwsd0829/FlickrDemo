//
//  ViewController.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "PageViewController.h"
//models
#import "Photo.h"
//views
#import "ImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils+DDHUI.h"


NSInteger const PreloadingOffset = 10; //must smaller than PageCount in FlickerService, otherwise no new page will loaded

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPageViewControllerDataSource> {
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //setup collectionview
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = flowLayout;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //setup Notifications
    [self setupNotifications];
    //setup dependencies: ViewModel
    [self setupViewModel];
    //kick off services;
    [self.viewModel loadImages];

}

-(void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kNetworkOfflineToOnline object:nil];
}

-(void)setupViewModel {
    typeof(self) __weak weakSelf = self;
    void(^updateBlock)() = ^() {
        ViewController* strongSelf = weakSelf;
        [strongSelf.collectionView reloadData];
    };

    self.viewModel.updateBlock = updateBlock;
}

//MARK: user actions & notifications
//- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender {
//    if(self.viewModel.type == ImageListTypeRecent && sender.selectedSegmentIndex == ImageListTypeInteresting) {
//        self.tabBarController.selectedIndex = ImageListTypeInteresting;
//        [self.viewModel segmentedControlChangedTo:ImageListTypeInteresting];
//    }
//    if(self.viewModel.type == ImageListTypeInteresting && sender.selectedSegmentIndex == ImageListTypeRecent) {
//        self.tabBarController.selectedIndex = ImageListTypeRecent;
//        [self.viewModel segmentedControlChangedTo:ImageListTypeRecent];
//    }
//}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // [self setupSegmentControlIndex];
}

//-(void)setupSegmentControlIndex {
//    if(self.viewModel.type == ImageListTypeRecent) {
//        self.segmentedControl.selectedSegmentIndex = (int)ImageListTypeRecent;
//    }
//    if(self.viewModel.type == ImageListTypeInteresting) {
//        self.segmentedControl.selectedSegmentIndex = (int)ImageListTypeInteresting;
//    }
//}

//reload to trigger network reloading from Offline to onLine
-(void)networkChanged:(NSNotification*) notification {
    [self.collectionView reloadData];
}

//MARK: collectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.viewModel.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    [self p_configCell:cell forItemAtIndexPath:indexPath];
    return cell;
}

-(void) p_configCell:(UICollectionViewCell*)cell forItemAtIndexPath:(NSIndexPath*) indexPath {
    if([cell isKindOfClass:[ImageCell class]]) {
        ImageCell* imageCell = (ImageCell*)cell;
        imageCell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageCell.imageView.layer.masksToBounds=YES;
        //use SDWebImage and comment below for better performance
        //[imageCell.imageView sd_setImageWithURL:[NSURL URLWithString:  self.viewModel.photos[indexPath.row].originalImageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        imageCell.imageView.image = [self.viewModel.cacheService imageForName:self.viewModel.photos[indexPath.row].originalImageUrlString];
        //Handle image caching in ViewModel layer
        [self.viewModel loadImageForIndexPath:indexPath withHandler:^(UIImage *image) {
                 //make sure cell still visible
            ImageCell *updateCell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
            if (updateCell){
                //some annimation effect, Bug: not always animate
                [UIView transitionWithView:imageCell.imageView
                                  duration:1.0f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    imageCell.imageView.image = image;
                                } completion:nil];
            }
        }];
    }
    
    //NSLog(@"indexPath: %@", indexPath);
    if(indexPath.row + PreloadingOffset == self.viewModel.photos.count) {
        [self.viewModel loadImages];
    }
}

//MARK: collectionView delegate (UICollectionViewDelegateFlowLayout)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake((self.collectionView.bounds.size.width- 30) / 2 , 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController* dvc = [self createDetailPage];
    dvc.photo = self.viewModel.photos[indexPath.item];
    PageViewController* pvc = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [pvc setViewControllers:@[dvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    pvc.dataSource = self;
    pvc.edgesForExtendedLayout = UIRectEdgeBottom;
    [self.navigationController pushViewController:pvc animated:YES];
}

//can put in a Category
//Mark: Page Navigation
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if(![viewController isKindOfClass: [DetailViewController class]]) {
        return nil;
    }
    DetailViewController* oldVC = (DetailViewController*)viewController;
    DetailViewController* dvc = [self createDetailPage];
    dvc.photo = [self.viewModel previousPhotoFor:oldVC.photo];
    return dvc;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if(![viewController isKindOfClass: [DetailViewController class]]) {
        return nil;
    }
    DetailViewController* oldVC = (DetailViewController*)viewController;
    DetailViewController* dvc = [self createDetailPage];
    dvc.photo = [self.viewModel nextPhotoFor: oldVC.photo];
    return dvc;
}

-(DetailViewController*) createDetailPage{
    DetailViewController* dvc = [Utils viewControllerWithIdentifier:@"DetailViewController" fromStoryBoardNamed: @"Main"];
    dvc.navigationItem.title=@"Gallery";
    dvc.navigationController.navigationBar.topItem.title = @"gallery";
    //create create New viewModel for Detail, here for simplicity;
    dvc.viewModel = self.viewModel;
    
    return dvc;
}

//MARK: rotation
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    [self.collectionView.collectionViewLayout invalidateLayout];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
       // [self.collectionView reloadData];
    }];
}

@end
