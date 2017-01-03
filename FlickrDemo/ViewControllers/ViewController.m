//
//  ViewController.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"
#import "OpenPageAnimator.h"
//models
#import "Photo.h"
//views
#import "ImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils+DDHUI.h"
#import "UIViewController+Navigations.h"

NSInteger const PreloadingOffset = 10; //must smaller than PageCount in FlickerService, otherwise no new page will loaded

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate> {
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
    
    self.navigationController.delegate = self;
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // [self setupSegmentControlIndex];
}

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

//MARK: Transition

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PageViewController* pvc = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self setupPageViewController:pvc withIndexPath: indexPath];
    [self.navigationController pushViewController:pvc animated:YES];
}

-(void)setupPageViewController: (PageViewController*) pvc withIndexPath:(NSIndexPath*)indexPath{
    
    pvc.dataSource = pvc;  //pvc's navigation controller not set yet!
    pvc.viewModel = self.viewModel;
    pvc.edgesForExtendedLayout = UIRectEdgeBottom;
    DetailViewController* dvc = [pvc createDetailPage];
    dvc.photo = self.viewModel.photos[indexPath.item];
    [pvc setViewControllers:@[dvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    //get frame to start animation
    UICollectionViewLayoutAttributes* attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellRect = attributes.frame;
    CGRect cellFrameInSuperview = [self.collectionView convertRect:cellRect toView:[self.collectionView superview]];
    pvc.fromFrame = cellFrameInSuperview;
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    //fromVC: HostViewController, toVC: PageViewController
    //all properties of self is deallocated.
    if([toVC isKindOfClass: [PageViewController class]]) {
        OpenPageAnimator* opa = [[OpenPageAnimator alloc] init];
        opa.delegate = ((PageViewController*)toVC);//((PageViewController*)toVC).fromCellFrame;
        //???
        //po ((ViewController*)(((HostViewController*)fromVC)->tabBarViewController.viewControllers[0])).viewModel (has value)
        //po self.viewModel  (is nil)
        opa.presenting = YES;
        return opa;
    }
    return nil;
}

//MARK: rotation
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    // Code here will execute before the rotation begins. Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    [self.collectionView.collectionViewLayout invalidateLayout];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Place code here to perform animations during the rotation. You can pass nil or leave this block empty if not necessary.
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // Code here will execute after the rotation has finished, Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
    }];
}



@end
