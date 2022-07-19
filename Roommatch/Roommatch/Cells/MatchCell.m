//
//  MatchCell.m
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import "MatchCell.h"

@implementation MatchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithUserObject:(User *)user {
    self.nameLabel.text = user.name;
    self.instagramLabel.text = user.instagramTag;
    self.profilePictureImageView.file = user.profilePicture;
    [self.profilePictureImageView loadInBackground];
}

@end
