//
//  SwipeView.m
//  Roommatch
//
//  Created by Lily Yang on 7/21/22.
//

#import "SwipeView.h"

@implementation SwipeView

- (void)configureWithUserObject:(User *)user {
    self.nameAndAgeLabel.text = [[user.name stringByAppendingString:@", "] stringByAppendingString:user.age];
    self.bioLabel.text = user.bio;
    self.profilePictureImageView.file = user.profilePicture;
    [self.profilePictureImageView loadInBackground];
}

- (IBAction)tapSeeMoreDetails:(id)sender {
    [self.delegate showDetailedView]; 
}

@end
