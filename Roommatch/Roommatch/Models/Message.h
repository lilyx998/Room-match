//
//  Message.h
//  Roommatch
//
//  Created by Lily Yang on 7/25/22.
//

#import <Parse/Parse.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Message : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) User *fromUser;

@end

NS_ASSUME_NONNULL_END
