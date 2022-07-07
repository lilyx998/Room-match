//
//  AppDelegate.m
//  Roommatch
//
//  Created by Lily Yang on 7/5/22.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

        configuration.applicationId = [dict objectForKey: @"App ID"];
        configuration.clientKey = [dict objectForKey: @"Client Key"];
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];
    
//    PFObject *test = [PFObject objectWithClassName:@"Person"];
////    NSMutableArray *array = [[NSMutableArray alloc]init]; //alloc
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    [array addObject:@"Lily"];
//    test[@"usersSeen"] = array;
//    [test[@"usersSeen"] addObject:@"Claire"];
//    [test saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"Object saved!");
//        } else {
//            NSLog(@"Error: %@", error.description);
//        }
//    }];
//    
//    PFQuery *query = [PFQuery queryWithClassName:@"Person"];
//    
//    query.limit = 20;
//    [query whereKey:@"usersSeen" notEqualTo:@"Lily"];
//    // Find objects where "usersSeen" field is an array and does not contains current user's username
//    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
//        if (users != nil) {
//            NSLog(@"%@", [@(users.count) stringValue]);
//            for(PFObject* user in users){
//                NSLog(@"%@", user.description);
//            }
//        } else {
//            NSLog(@"%@", error.localizedDescription);
//        }
//    }];

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
