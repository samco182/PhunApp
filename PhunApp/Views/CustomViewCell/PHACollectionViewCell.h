//
//  PHACollectionViewCell.h
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHACollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingPlaceTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionTextLabel;

@end
