//
//  PHAHomeCollectionViewController.m
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import <Realm/RLMRealm.h>
#import <Realm/RLMResults.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PHAHomeCollectionViewController.h"
#import "PHACollectionViewCell.h"
#import "PHADetailViewController.h"
#import "PHASpotlightHelper.h"
#import "PHADataFetcher.h"
#import "PHAEventStoring.h"
#import "PHAEvent.h"

@interface PHAHomeCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic) CGFloat itemsPerRow;
@property (strong, nonatomic) PHADataFetcher *dataFetcher;
@property (strong, nonatomic) PHASpotlightHelper *helper;
@property (strong, nonatomic) RLMResults *events;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation PHAHomeCollectionViewController

static NSString * const reuseIdentifier = @"Meeting Cell";
static NSString *const FEED_URL = @"https://raw.githubusercontent.com/phunware/dev-interview-homework/master/feed.json";
static NSString *const DETAIL_SEGUE = @"Show Details";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PHACollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self refreshItemsPerRow];
    [self startFetchingDataToDisplay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self refreshItemsPerRow];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
}

#pragma mark - Setter/Getters

- (PHADataFetcher *)dataFetcher {
    if (!_dataFetcher) {
        _dataFetcher = [PHADataFetcher new];
    }
    return _dataFetcher;
}

- (PHASpotlightHelper *)helper {
    if (!_helper) {
        _helper = [PHASpotlightHelper new];
    }
    return _helper;
}

- (void)setSpotlightItemID:(NSString *)spotlightItemID {
    _spotlightItemID = spotlightItemID;
    [self forwardToDetailEventID:spotlightItemID];
}

- (void)setDeepLinkingItemID:(NSString *)deepLinkingItemID {
    _deepLinkingItemID = deepLinkingItemID;
    [self forwardToDetailEventID:deepLinkingItemID];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.events.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHAEventStoring *event = [self.events objectAtIndex:indexPath.row];
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:event.imageURL]
                                placeholderImage:[UIImage imageNamed:@"placeholder_nomoon"]
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           if (indexPath.row == ([self.events count]-1)) {
                                               [self.indicator stopAnimating];
                                           }
                                       }];
    cell.titleTextLabel.text = event.eventTitle;
    cell.dateTextLabel.text = [[self dateFormatter] stringFromDate:event.eventDate];
    cell.shortDescriptionTextLabel.text = [([event.eventDescription componentsSeparatedByString:@"."])[0] stringByAppendingString:@"."];
    if (event.locationTwo) {
        cell.meetingPlaceTextLabel.text = [NSString stringWithFormat:@"%@, %@", event.locationOne, event.locationTwo];
    } else {
        cell.meetingPlaceTextLabel.text = event.locationOne;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(nonnull UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CGFloat widthPerItem = self.collectionView.frame.size.width / self.itemsPerRow;
    
    return CGSizeMake(widthPerItem, widthPerItem * 0.48);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero.left;
}

#pragma mark - Fetching

- (void)startFetchingDataToDisplay {
    [self setupActivityIndicator];
    [self.dataFetcher getDataFromURL:FEED_URL
                           onSuccess:^(PHAEventList *response) {
                               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                   @autoreleasepool {
                                       
                                       RLMRealm *realm = [RLMRealm defaultRealm];
                                       [realm beginWriteTransaction];
                                       [realm deleteAllObjects];
                                       [realm commitWriteTransaction];
                                       
                                       [realm beginWriteTransaction];
                                       for(PHAEvent *event in response.events){
                                           PHAEventStoring *eventStoring = [[PHAEventStoring alloc] initWithMantleModel:event];
                                           [realm addObject:eventStoring];
                                       }
                                       
                                       [realm commitWriteTransaction];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           RLMRealm *realmMainThread = [RLMRealm defaultRealm];
                                           RLMResults *events = [PHAEventStoring allObjectsInRealm:realmMainThread];
                                           self.events = events;
                                           [self.helper indexIntoSpotlight:self.events];
                                           [self.collectionView reloadData];
                                       });
                                   }
                               });
                           } failure:^(NSError *error) {
                               [self alert:error];
                               self.events = [PHAEventStoring allObjects];
                               [self.helper indexIntoSpotlight:self.events];
                               [self.collectionView reloadData];
                           }];
}

#pragma mark - Navigation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:DETAIL_SEGUE sender:self.events[indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

        if ([segue.destinationViewController isKindOfClass:[PHADetailViewController class]]) {
            PHADetailViewController *detailViewController = (PHADetailViewController *)segue.destinationViewController;
            detailViewController.eventToDisplay = sender;
        }
}

#pragma mark - Helper Methods

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy 'at' hh:mm a"];;
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    return dateFormatter;
}

- (void)orientationChanged:(NSNotification *)notification {
    [self refreshItemsPerRow];
}

- (void)refreshItemsPerRow {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;\
    
    UIDevice* thisDevice = [UIDevice currentDevice];
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.itemsPerRow = 2;
    } else if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if (orientation == UIInterfaceOrientationPortrait) {
            self.itemsPerRow = 1;
        } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            self.itemsPerRow = 2;
        }
    }
    [self.collectionView reloadData];
}

- (void)setupActivityIndicator {
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.frame = CGRectMake((rect.size.width-50)/2, (rect.size.height-50)/2, 50, 50);
    self.indicator.hidesWhenStopped = YES;
    self.indicator.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.indicator];
    
    [self.indicator startAnimating];
}

- (void)forwardToDetailEventID:(NSString *)eventID {
    PHAEventStoring *event = [PHAEventStoring objectForPrimaryKey:@([eventID integerValue])];
    [self performSegueWithIdentifier:DETAIL_SEGUE sender:event];
}

- (void)alert:(NSError *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:[msg localizedDescription]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
