//
//  Chat.m
//  Roommatch
//
//  Created by Lily Yang on 7/25/22.
//

#import "Chat.h"

@implementation Chat

@dynamic user1;
@dynamic user2;
@dynamic lastMessageText;
@dynamic messages;

+ (nonnull NSString *)parseClassName {
    return @"Chat"; 
}

@end
