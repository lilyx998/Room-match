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
#import "Message.h"
#import "Utils.h"

@interface MatchesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *chatsToDisplay;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryAndDisplayChats) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.searchBar.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void) viewWillAppear:(BOOL)animated {
    [self queryAndDisplayChats];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
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
    [query includeKey:@"messages"]; 
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Chat *chat = self.chatsToDisplay[indexPath.row];
    for(Message *message in chat.messages){
        [message delete];
    }
    [self.chatsToDisplay removeObjectAtIndex:indexPath.row];
    [chat deleteInBackground];
    [tableView reloadData];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatsToDisplay.count;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    
    [self addFiltersToQuery:query fromSearchString:searchBar.text];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for(Message *message in objects){
            NSLog(@"%@", message.description);
        }
    }];
}

- (void)addFiltersToQuery:(PFQuery *)query fromSearchString:(NSString *)searchString {
    NSArray *tokens = [searchString componentsSeparatedByString:@" "];
    
    for(NSString *token in tokens){
        if([token hasPrefix:@"from:"]){ // WORKS
            NSString *username = [token substringFromIndex:5];
            [query whereKey:@"fromUser" equalTo:[User getUserFromUsername:username]];
        }
        else if([token hasPrefix:@"to:"]){ // WORKS
            NSString *username = [token substringFromIndex:3];
            [query whereKey:@"toUser" equalTo:[User getUserFromUsername:username]];
        }
        else if([token hasPrefix:@"beforeDate:"]){ // WORKS
            NSString *dateString = [token substringFromIndex:11]; //MM-DD-YYYY
            NSDate *date = [Utils getDateFromString:dateString];
            [query whereKey:@"updatedAt" lessThan:date];
        }
        else if([token hasPrefix:@"duringDate"]){ // INCLUDE TIME
            NSString *dateString = [token substringFromIndex:11];
            NSDate *date = [Utils getDateFromString:dateString];
            [query whereKey:@"updatedAt" equalTo:date];
        }
        else if([token hasPrefix:@"afterDate:"]){ // INCLUDE TIME
            NSString *dateString = [token substringFromIndex:10];
            NSDate *date = [Utils getDateFromString:dateString];
            [query whereKey:@"updatedAt" greaterThan:date];
        }
        else if([token hasPrefix:@"includesText:"]){ // WORKS 
            NSString *text = [token substringFromIndex:13];
            [query whereKey:@"text" containsString:text];
        }
    }
}

@end
