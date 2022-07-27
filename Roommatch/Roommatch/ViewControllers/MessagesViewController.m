//
//  MessagesViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/26/22.
//

#import "MessagesViewController.h"
#import "ParseLiveQuery/ParseLiveQuery-umbrella.h"
#import "ProfileDetailsViewController.h"
#import "Message.h"
#import "MessageCell.h"

@interface MessagesViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitleItem;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (strong, nonatomic) PFLiveQueryClient *liveQueryClient;
@property (strong, nonatomic) PFQuery *msgQuery;
@property (strong, nonatomic) PFLiveQuerySubscription *subscription;

@property (strong, nonatomic) User *otherUser;
@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.otherUser = [self getOtherUser];
    self.messages = [NSMutableArray arrayWithArray:self.chat.messages];
    
    [self setUpLiveQuery];
    
    [self registerForKeyboardNotifications];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.messagesTableView.dataSource = self;
    self.messagesTableView.transform = CGAffineTransformMakeScale(1, -1);
    [self.messagesTableView reloadData];
    
    self.navigationTitleItem.title = self.otherUser.name;
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
                [strongSelf.messagesTableView reloadData];
            });
        }
       
    }];
}

- (IBAction)tapSendButton:(id)sender {
    Message *newMessage = [Message new];
    newMessage.fromUser = [User currentUser];
    newMessage.toUser = self.otherUser; 
    newMessage.text = self.inputTextField.text;
    
    self.inputTextField.text = @"";
    
    [newMessage save];
    
    [self.messages addObject:newMessage];
    [self.chat addObject:newMessage forKey:@"messages"];
    self.chat.lastMessageText = newMessage.text;
    [self.chat save];
    [self.messagesTableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Message *message = self.messages[self.messages.count - indexPath.row - 1];
    [message fetchIfNeeded];
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
    cell.messageTextLabel.text = message.text;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileDetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.user = self.otherUser;
}

- (User *)getOtherUser {
    return [self.chat.user1.objectId isEqualToString:[User currentUser].objectId] ? self.chat.user2 : self.chat.user1;
}

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

-(void)hideKeyboard {
    [self.view endEditing:YES];
}

@end
