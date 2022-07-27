//
//  MatchesViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import "MatchesViewController.h"
#import "User.h"
#import "Chat.h"
#import <Parse/Parse.h>
#import "ChatCell.h"
#import "TheirProfileDetailsViewController.h"
#import "MessagesViewController.h"

@interface MatchesViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *chatsToDisplay;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryAndDisplayChats) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.tableView.dataSource = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [self queryAndDisplayChats];
}

- (void)queryAndDisplayChats {
    self.chatsToDisplay = [NSMutableArray array];
    User *curUser = [User currentUser];
    
    PFQuery *queryCurrentUserIsUser1 = [PFQuery queryWithClassName:@"Chat"];
    [queryCurrentUserIsUser1 whereKey:@"user1" equalTo:curUser];
    PFQuery *queryCurrentUserIsUser2 = [PFQuery queryWithClassName:@"Chat"];
    [queryCurrentUserIsUser2 whereKey:@"user2" equalTo:curUser];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryCurrentUserIsUser1, queryCurrentUserIsUser2]];
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *chats, NSError *error) {
        if (chats) {
            [self.chatsToDisplay addObjectsFromArray:chats];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    Chat *chatToPass = self.chatsToDisplay[indexPath.row];
    MessagesViewController *messagesVC = [segue destinationViewController];
    messagesVC.chat = chatToPass;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell" forIndexPath:indexPath];

    Chat* chat = self.chatsToDisplay[indexPath.row];
    [cell initWithChatObject:chat];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatsToDisplay.count;
}

@end
