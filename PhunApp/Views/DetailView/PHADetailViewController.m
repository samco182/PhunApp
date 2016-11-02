//
//  PHADetailViewController.m
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import "PHADetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PHADetailViewController () <UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UINavigationItem *nagivationItem;
@property (weak, nonatomic) IBOutlet UIImageView *gradientImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;

@end

@implementation PHADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self applyGradientToImageView];
    [self makeNavigationBarTransparent];
    [self fillUpTextFields];
}

#pragma mark - UI

- (void)makeNavigationBarTransparent {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)applyGradientToImageView {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.eventToDisplay.imageURL] placeholderImage:[UIImage imageNamed:@"placeholder_nomoon"]];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.imageView.frame;
    layer.colors = @[(__bridge id)[UIColor clearColor].CGColor,   // start color
                     (__bridge id)[UIColor whiteColor].CGColor]; // end color
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.gradientImageView.image = image;
}

- (void)fillUpTextFields {
    self.dateTextLabel.text = [[self dateFormatter] stringFromDate:self.eventToDisplay.eventDate];
    self.titleTextLabel.text = self.eventToDisplay.eventTitle;
    self.eventDescriptionTextView.text = self.eventToDisplay.eventDescription;
}

#pragma mark - Helper Methods

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy 'at' hh:mm a"];;
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    return dateFormatter;
}

- (IBAction)shareButton:(UIBarButtonItem *)sender {
    NSString *textToShare = [NSString stringWithFormat:@"Attend to event: %@", self.eventToDisplay.eventTitle];
    NSString *eventDate = [[self dateFormatter] stringFromDate:self.eventToDisplay.eventDate];
    NSURL *myWebsite = self.eventToDisplay.imageURL ? [NSURL URLWithString:self.eventToDisplay.imageURL] : [NSURL URLWithString:@"placeholder_nomoon"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite, eventDate];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    activityVC.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:activityVC animated:YES completion:nil];
    
    UIPopoverPresentationController* pp = activityVC.popoverPresentationController;
    pp.barButtonItem = sender;
}

@end
