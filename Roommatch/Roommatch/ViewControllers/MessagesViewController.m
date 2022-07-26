//
//  MessagesViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/26/22.
//

#import "MessagesViewController.h"
#import "ProfileDetailsViewController.h"
#import "Message.h"
#import "MessageCell.h"

@interface MessagesViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitleItem;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic) NSUInteger messagesCount;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messagesCount = self.chat.messages.count;
    
    self.messagesTableView.dataSource = self;
    self.messagesTableView.transform = CGAffineTransformMakeScale(1, -1);
    [self.messagesTableView reloadData];
    
    User *otherUser = [self getOtherUser];
    
    self.navigationTitleItem.title = otherUser.name;
}

- (IBAction)tapSendButton:(id)sender {
    Message *newMessage = [Message new];
    newMessage.fromUser = [User currentUser];
    newMessage.text = self.inputTextField.text;
    
    self.inputTextField.text = @"";
    
    [newMessage saveInBackground];
    
    [self.chat addObject:newMessage forKey:@"messages"];
    [self.chat saveInBackground];
    self.messagesCount = self.chat.messages.count;
    [self.messagesTableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Message *message = self.chat.messages[self.messagesCount - indexPath.row - 1];
    [message fetchIfNeeded];
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
    cell.messageTextLabel.text = message.text;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesCount;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    User *user = [self getOtherUser];
    ProfileDetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.user = user;
}

- (User *)getOtherUser {
    return [self.chat.user1.objectId isEqualToString:[User currentUser].objectId] ? self.chat.user2 : self.chat.user1;
}

@end
