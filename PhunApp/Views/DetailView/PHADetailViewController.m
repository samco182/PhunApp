//
//  PHADetailViewController.m
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import "PHADetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PHADetailViewController ()
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI

- (void)makeNavigationBarTransparent {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)applyGradientToImageView {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.eventToDisplay.imageURL]];
    
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

@end
