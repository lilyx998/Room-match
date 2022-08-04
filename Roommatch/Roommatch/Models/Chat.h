//
//  Chat.h
//  Roommatch
//
//  Created by Lily Yang on 7/25/22.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chat : PFObject<PFSubclassing>

@property (strong, nonatomic) User* user1;
@property (strong, nonatomic) User* user2;
@property (strong, nonatomic) NSString* lastMessageText;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDate *user1LastSeenDate;
@property (strong, nonatomic) NSDate *user2LastSeenDate;
@property (strong, nonatomic) NSDate *lastMessageDate; 

@end

NS_ASSUME_NONNULL_END
