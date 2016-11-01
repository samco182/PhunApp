//
//  PHADetailViewController.h
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHAEventStoring.h"

@interface PHADetailViewController : UIViewController

@property (strong, nonatomic) PHAEventStoring *eventToDisplay;

@end
