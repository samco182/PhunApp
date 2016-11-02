//
//  AppDelegate.m
//  PhunApp
//
//  Created by Samuel Cornejo on 10/31/16.
//  Copyright © 2016 Applaudo Studios. All rights reserved.
//

#import "AppDelegate.h"
#import "PHAHomeCollectionViewController.h"
#import <CoreSpotlight/CoreSpotlight.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
        UINavigationController *controller = (UINavigationController *)self.window.rootViewController;
        PHAHomeCollectionViewController *rootController = controller.viewControllers.firstObject;
        rootController.spotlightItemID = [userActivity.userInfo objectForKey:CSSearchableItemActivityIdentifier];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"phunapp"]) {
        UINavigationController *controller = (UINavigationController *)self.window.rootViewController;
        PHAHomeCollectionViewController *rootController = controller.viewControllers.firstObject;
        NSString *string = ([url.absoluteString componentsSeparatedByString:@"?"])[1];
        NSString *formattedString = ([string componentsSeparatedByString:@"="])[1];
        rootController.deepLinkingItemID = formattedString;
    }
    
    return YES;
}


@end
