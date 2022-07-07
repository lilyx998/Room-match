//
//  User.h
//  Roommatch
//
//  Created by Lily Yang on 7/7/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser

@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) User *bestie; 



@end

NS_ASSUME_NONNULL_END
