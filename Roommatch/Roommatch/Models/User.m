//
//  User.m
//  Roommatch
//
//  Created by Lily Yang on 7/7/22.
//

#import "User.h"
#import "Utils.h"

@implementation User

@dynamic name;
@dynamic age;
@dynamic pronouns;
@dynamic priceLow;
@dynamic priceHigh;
@dynamic profilePicture;
@dynamic city;
@dynamic bio;
@dynamic smoking;
@dynamic pets;
@dynamic inCollege;
@dynamic collegeName;
@dynamic profileCreated;
@dynamic usersSeen;

- (void)initAllEmpty {
    self.age = @"";
    self.pronouns = @"";
    self.priceLow = [NSNumber numberWithInt:(-1)];
    self.priceHigh = [NSNumber numberWithInt:(-1)];
    self.profilePicture = [Utils getPFFileFromImage:[UIImage imageNamed:@"Profile Picture Placeholder"]];
    self.city = @"";
    self.bio = @"";
    self.smoking = @"";
    self.pets = @"";
    self.inCollege = @"";
    self.collegeName = @"";
    self.profileCreated = NO;
    self.usersSeen = [NSMutableArray array]; 
}

@end
