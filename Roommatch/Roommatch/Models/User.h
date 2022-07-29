//
//  User.h
//  Roommatch
//
//  Created by Lily Yang on 7/7/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* age;
@property (strong, nonatomic) NSString* pronouns;

@property (strong, nonatomic) NSNumber* priceLow;
@property (strong, nonatomic) NSNumber* priceHigh;

@property (strong, nonatomic) PFFileObject* profilePicture; 
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* bio;
@property (strong, nonatomic) NSString* smoking;
@property (strong, nonatomic) NSString* pets;
@property (strong, nonatomic) NSString* inCollege;
@property (strong, nonatomic) NSString* collegeName;
@property (nonatomic) BOOL profileCreated;

@property (strong, nonatomic) NSMutableArray *usersSeen;

- (void)initAllEmpty; 

@end

NS_ASSUME_NONNULL_END
