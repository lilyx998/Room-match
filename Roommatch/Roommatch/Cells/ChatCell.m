//
//  MatchCell.m
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import "ChatCell.h"
#import "Chat.h"

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithChatObject:(Chat *)chat {
    User *curUser = [User currentUser];
    User *them = [chat.user1.objectId isEqualToString:curUser.objectId] ? chat.user2 : chat.user1;
    [them fetchIfNeeded]; 
    
    self.nameLabel.text = them.name;
    self.profilePictureImageView.file = them.profilePicture;
    [self.profilePictureImageView loadInBackground];
    self.lastMessagePreview.text = chat.lastMessageText;
}

@end
