//
//  SceneDelegate.m
//  Roommatch
//
//  Created by Lily Yang on 7/5/22.
//

#import "SceneDelegate.h"
#import "User.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    User *user = [User currentUser];
    if (user) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if(user.profileCreated)
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabController"];
        else
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"CreateProfileNavController"];
    }
}

- (void)sceneDidDisconnect:(UIScene *)scene {}

- (void)sceneDidBecomeActive:(UIScene *)scene {}

- (void)sceneWillResignActive:(UIScene *)scene {}

- (void)sceneWillEnterForeground:(UIScene *)scene {}

- (void)sceneDidEnterBackground:(UIScene *)scene {}


@end
