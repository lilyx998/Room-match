//
//  MatchCell.m
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import "ChatCell.h"
#import "Chat.h"
#import "Message.h"

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWithChatObject:(Chat *)chat {
    User *curUser = [User currentUser];
    BOOL amUser1 = [chat.user1.objectId isEqualToString:curUser.objectId];
    User *them = amUser1 ? chat.user2 : chat.user1;
    [them fetchIfNeeded];
    
    NSDate *lastOpenedByMe = amUser1 ? chat.user1LastSeenDate : chat.user2LastSeenDate;
    self.unreadIndicatorImageView.hidden = !(!lastOpenedByMe || (chat.lastMessageDate && ![chat.lastMessageDate isEqualToDate:lastOpenedByMe] && [[lastOpenedByMe earlierDate:chat.lastMessageDate] isEqualToDate:lastOpenedByMe]));
    
    self.nameLabel.text = them.name;
    self.profilePictureImageView.file = them.profilePicture;
    [self.profilePictureImageView loadInBackground];
    self.lastMessagePreview.text = chat.lastMessageText;
}

@end
