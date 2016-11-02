//
//  PHASpotlightHelper.m
//  PhunApp
//
//  Created by Samuel Cornejo on 11/1/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import "PHASpotlightHelper.h"
#import "SDImageCache.h"

@implementation PHASpotlightHelper

- (void)indexIntoSpotlight:(RLMResults *)events {
    if (![CSSearchableIndex isIndexingAvailable]) {
        return;
    }
    
    NSMutableArray* spotlightItems = [NSMutableArray new];
    
    for (PHAEventStoring* event in events) {
        
        CSSearchableItemAttributeSet* itemAttributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString*)kUTTypeData];
        
        itemAttributes.title = event.eventTitle;
        itemAttributes.contentDescription= event.eventDescription;
        
        CSSearchableItem* item = [[CSSearchableItem alloc] initWithUniqueIdentifier:event.eventID.stringValue domainIdentifier:@"Event Spotilight Item" attributeSet:itemAttributes];
        [spotlightItems addObject:item];
    }
    
    // Add the item to the on-device index.
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:spotlightItems completionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Items idenxed",nil);
        }else{
            NSLog(@"Error on Items idenx %@",error.localizedDescription);
        }
    }];
}

@end
