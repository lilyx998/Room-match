//
//  SendMessageCell.m
//  Roommatch
//
//  Created by Lily Yang on 7/28/22.
//

#import "SendMessageCell.h"

@implementation SendMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bubbleView.layer.cornerRadius = 25;
    self.userProfilePicture.layer.cornerRadius = self.userProfilePicture.frame.size.width /2;
    self.userProfilePicture.layer.masksToBounds = YES;
}

- (void)configureWithMessageObject:(Message *)message {
    self.userProfilePicture.file = message.fromUser.profilePicture;
    [self.userProfilePicture loadInBackground];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    self.timestampLabel.text = [formatter stringFromDate:message.updatedAt];
    
    self.messageTextLabel.text = message.text;
}

@end
