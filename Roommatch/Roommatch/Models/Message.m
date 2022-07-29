//
//  Message.m
//  Roommatch
//
//  Created by Lily Yang on 7/25/22.
//

#import "Message.h"

@implementation Message

@dynamic text;
@dynamic fromUser;
@dynamic toUser; 

+ (nonnull NSString *)parseClassName { 
    return @"Message"; 
}

@end
