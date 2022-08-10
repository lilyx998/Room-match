//
//  MessagesViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/26/22.
//

#import "MessagesViewController.h"
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"
#import "TheirProfileDetailsViewController.h"
#import "Message.h"
#import "SendMessageCell.h"
#import "ReceiveMessageCell.h"

static const int fetchAmount = 10;

@interface MessagesViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitleItem;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fetchMoreMessagesActivityIndicator;

@property (strong, nonatomic) PFLiveQueryClient *liveQueryClient;
@property (strong, nonatomic) PFQuery *msgQuery;
@property (strong, nonatomic) PFLiveQuerySubscription *subscription;

@property (strong, nonatomic) User *otherUser;
@property (strong, nonatomic) NSMutableArray<Message *> *messages;

@property (nonatomic) NSInteger fetchedMessagesCount;
@property (nonatomic) BOOL amUser1;

@end

@implementation MessagesViewController


#pragma mark - View initialization and disappearing

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.otherUser = [self getOtherUser];
    self.messages = [NSMutableArray arrayWithArray:self.chat.messages];
    
    [self updateLastSeenDate];
    
    self.fetchedMessagesCount = 0;
    [self fetchMoreMessages];
    
    [self setUpLiveQuery];
    
    [self registerForKeyboardNotifications];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.messagesTableView.dataSource = self;
    self.messagesTableView.transform = CGAffineTransformMakeScale(1, -1);
    [self.messagesTableView reloadData];
    [self.messagesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.navigationTitleItem.title = self.otherUser.name;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.liveQueryClient disconnect];
}

- (void)setUpLiveQuery {
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *applicationId = [dict objectForKey: @"App ID"];
    NSString *clientKey = [dict objectForKey: @"Client Key"];
    self.liveQueryClient = [[PFLiveQueryClient alloc] initWithServer:@"wss://roommatch.b4a.io" applicationId:applicationId clientKey:clientKey];
    
    self.msgQuery = [PFQuery queryWithClassName:@"Message"];
    
    __weak typeof(self) weakSelf = self;
    self.subscription = [self.liveQueryClient subscribeToQuery:self.msgQuery];
    [self.subscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull message) {
        User *from = message[@"fromUser"];
        User *to = message[@"toUser"];
        if([from.objectId isEqualToString:self.otherUser.objectId] && [to.objectId isEqualToString:[User currentUser].objectId]){
            __strong typeof(self) strongSelf = weakSelf;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [strongSelf.messages addObject:message];
                strongSelf.fetchedMessagesCount++;
                [strongSelf.messagesTableView beginUpdates];
                NSIndexPath *row = [NSIndexPath indexPathForRow:0 inSection:0];
                [strongSelf.messagesTableView insertRowsAtIndexPaths: [NSArray arrayWithObject:row] withRowAnimation:UITableViewRowAnimationBottom ];
                [strongSelf.messagesTableView endUpdates];
                [strongSelf updateLastSeenDate];
            });
        }
    }];
}


#pragma mark - Send message

- (IBAction)tapSendButton:(id)sender {
    if(self.inputTextField.text.length == 0)
        return;
    
    Message *newMessage = [Message new];
    newMessage.fromUser = [User currentUser];
    newMessage.toUser = self.otherUser; 
    newMessage.text = self.inputTextField.text;
    
    self.inputTextField.text = @"";
    
    [newMessage save];
    
    [self.messages addObject:newMessage];
    self.fetchedMessagesCount++;
    [self.chat addObject:newMessage forKey:@"messages"];
    self.chat.lastMessageText = newMessage.text;
    self.chat.lastMessageDate = [[NSDate alloc] init]; 
    [self updateLastSeenDate];
    
    [self.messagesTableView beginUpdates];
    NSIndexPath *row = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.messagesTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:row] withRowAnimation:UITableViewRowAnimationBottom];
    [self.messagesTableView endUpdates];
}


#pragma mark - Table view of messages

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == self.fetchedMessagesCount-1 && indexPath.row != self.messages.count-1){
        [self fetchMoreMessages];
    }
    Message *message = self.messages[self.messages.count - indexPath.row - 1];
    [message.fromUser fetchIfNeeded];
    
    if([message.fromUser.objectId isEqualToString:[User currentUser].objectId]){
        SendMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sendCell" forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
        [cell configureWithMessageObject:message];
        return cell;
    }
    else {
        ReceiveMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"receiveCell" forIndexPath:indexPath];
        cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
        [cell configureWithMessageObject:message];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedMessagesCount;
}

- (void)fetchMoreMessages {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.fetchMoreMessagesActivityIndicator startAnimating];
        });
        
        NSInteger actualFetchAmount = MIN(fetchAmount, self.messages.count - self.fetchedMessagesCount);
        for(int i = 0; i<actualFetchAmount; i++){
            [self.messages[self.messages.count - self.fetchedMessagesCount - i - 1].fromUser fetchIfNeeded];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fetchedMessagesCount += actualFetchAmount;
            [self.messagesTableView reloadData];
            [self.fetchMoreMessagesActivityIndicator stopAnimating];
        });
    });
}


#pragma mark - Moving view above keyboard to avoid blocking

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    float newVerticalPosition = -keyboardSize.height;
    [self moveFrameToVerticalPosition:newVerticalPosition forDuration:0.3f];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self moveFrameToVerticalPosition:0.0f forDuration:0.3f];
}

- (void)moveFrameToVerticalPosition:(float)position forDuration:(float)duration {
    CGRect frame = self.view.frame;
    frame.origin.y = position;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = frame;
    }];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - Update for unread message indicator

- (void)updateLastSeenDate {
    if(self.amUser1)
        self.chat.user1LastSeenDate = [[NSDate alloc] init];
    else
        self.chat.user2LastSeenDate = [[NSDate alloc] init];
    [self.chat save];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TheirProfileDetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.user = self.otherUser;
}


#pragma mark - Helper functions

- (User *)getOtherUser {
    self.amUser1 = [self.chat.user1.objectId isEqualToString:[User currentUser].objectId];
    return self.amUser1 ? self.chat.user2 : self.chat.user1;
}

@end
