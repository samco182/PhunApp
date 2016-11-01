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
#import "PHADataFetcher.h"
#import "PHAEventStoring.h"
#import "PHAEvent.h"

@interface PHAHomeCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic) CGFloat itemsPerRow;
@property (strong, nonatomic) PHADataFetcher *dataFetcher;
@property (strong, nonatomic) RLMResults *events;

@end

@implementation PHAHomeCollectionViewController

static NSString * const reuseIdentifier = @"Meeting Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemsPerRow = [self getItemsPerRow];

    [self.collectionView registerNib:[UINib nibWithNibName:@"PHACollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Meeting Cell"];

    [self startFetchingDataToDisplay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
}

#pragma mark - Getters

- (PHADataFetcher *)dataFetcher {
    if (!_dataFetcher) {
        _dataFetcher = [PHADataFetcher new];
    }
    return _dataFetcher;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.events.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHAEventStoring *event = [self.events objectAtIndex:indexPath.row];
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:event.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
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
    
    CGFloat widthPerItem = self.view.frame.size.width / self.itemsPerRow;
    
    return CGSizeMake(widthPerItem, widthPerItem * 0.45);
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

#pragma mark - Helper Methods

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy 'at' hh:mm a"];;
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    return dateFormatter;
}

- (void)orientationChanged:(NSNotification *)notification {
    [self getItemsPerRow];
    [self.collectionView reloadData];
}

- (CGFloat)getItemsPerRow {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait) {
        self.itemsPerRow = 1;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.itemsPerRow = 2;
    }
    return self.itemsPerRow;
}

- (void)startFetchingDataToDisplay {
    [self.dataFetcher getDataFromURL:@"https://raw.githubusercontent.com/phunware/dev-interview-homework/master/feed.json"
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
                                           [self.collectionView reloadData];
                                       });
                                   }
                               });
                           } failure:^(NSError *error) {
                               NSLog(@"ERROR: %@",error);
                               self.events = [PHAEventStoring allObjects];
                               [self.collectionView reloadData];
                           }];
}

#pragma mark - Navigation

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *tappedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Show Details" sender:tappedCell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[PHACollectionViewCell class]]) {
        NSIndexPath *selectedCell = [self.collectionView indexPathForCell:sender];
        if ([segue.destinationViewController isKindOfClass:[PHADetailViewController class]]) {
            PHADetailViewController *detailViewController = (PHADetailViewController *)segue.destinationViewController;
            detailViewController.eventToDisplay = [self.events objectAtIndex:selectedCell.row];
        }
    }
}

@end
