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
#import "SearchMessageCell.h"

@interface MatchesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chatsTableView;
@property (strong, nonatomic) NSMutableArray *chatsToDisplay;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchMessagesTableView;
@property (strong, nonatomic) NSMutableArray *searchMessages;

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryAndDisplayChats) forControlEvents:UIControlEventValueChanged];
    [self.chatsTableView addSubview:self.refreshControl];
    
    self.searchBar.delegate = self;
    
    self.chatsTableView.delegate = self;
    self.chatsTableView.dataSource = self;
    self.searchMessagesTableView.dataSource = self;
    
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
            [self.chatsTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.chatsTableView indexPathForSelectedRow];
    
    Chat *chatToPass = self.chatsToDisplay[indexPath.row];
    MessagesViewController *messagesVC = [segue destinationViewController];
    messagesVC.chat = chatToPass;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(tableView == self.chatsTableView){
        ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell" forIndexPath:indexPath];

        Chat* chat = self.chatsToDisplay[indexPath.row];
        [cell initWithChatObject:chat];
        
        return cell;
    }
    else {
        SearchMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchMessageCell" forIndexPath:indexPath];
        Message *message = self.searchMessages[indexPath.row];
        [cell initWithMessageObject:message]; 
        return cell; 
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView == self.chatsTableView;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView != self.chatsTableView)
        return;
    Chat *chat = self.chatsToDisplay[indexPath.row];
    for(Message *message in chat.messages){
        [message delete];
    }
    [self.chatsToDisplay removeObjectAtIndex:indexPath.row];
    [chat deleteInBackground];
    [tableView reloadData];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.chatsTableView)
        return self.chatsToDisplay.count;
    return self.searchMessages.count;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchMessagesTableView.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.searchMessagesTableView.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    User *curUser = [User currentUser];
    PFQuery *queryCurrentUserIsFromUser = [PFQuery queryWithClassName:@"Message"];
    [queryCurrentUserIsFromUser whereKey:@"fromUser" equalTo:curUser];
    PFQuery *queryCurrentUserIsToUser = [PFQuery queryWithClassName:@"Message"];
    [queryCurrentUserIsToUser whereKey:@"toUser" equalTo:curUser];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryCurrentUserIsFromUser, queryCurrentUserIsToUser]];
    [query orderByDescending:@"updatedAt"];
    [query includeKey:@"fromUser"]; 
    [query includeKey:@"text"];
    
    [self addFiltersToQuery:query fromSearchString:searchBar.text];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.searchMessages = [NSMutableArray arrayWithArray:objects];
        [self.searchMessagesTableView reloadData];
    }];
}

- (void)addFiltersToQuery:(PFQuery *)query fromSearchString:(NSString *)searchString {
    NSArray *tokens = [searchString componentsSeparatedByString:@" "];
    
    for(NSString *token in tokens){
        if([token hasPrefix:@"from:"]){
            NSString *username = [token substringFromIndex:5];
            User *user = [User getUserFromUsername:username];
            if(user)
                [query whereKey:@"fromUser" equalTo:user];
        }
        else if([token hasPrefix:@"to:"]){
            NSString *username = [token substringFromIndex:3];
            User *user = [User getUserFromUsername:username];
            if(user)
                [query whereKey:@"toUser" equalTo:user];
        }
        else if([token hasPrefix:@"beforeDate:"]){
            NSString *dateString = [token substringFromIndex:11];
            NSDate *date = [Utils getDateFrom_MM_dd_YYYY_String:dateString];
            [query whereKey:@"updatedAt" lessThan:date];
        }
        else if([token hasPrefix:@"duringDate"]){
            NSString *dateString = [token substringFromIndex:11];
            NSDate *date = [Utils getDateFrom_MM_dd_YYYY_String:dateString];
            [query whereKey:@"updatedAt" greaterThanOrEqualTo:date];
            
            dateString = [dateString stringByAppendingString:@" 23:59:59"];
            date = [Utils getDateFrom_MM_dd_YYYY_HH_mm_ss_String:dateString];
            [query whereKey:@"updatedAt" lessThan:date];
        }
        else if([token hasPrefix:@"afterDate:"]){
            NSString *dateString = [[token substringFromIndex:10] stringByAppendingFormat:@" 23:59:59"];
            NSDate *date = [Utils getDateFrom_MM_dd_YYYY_HH_mm_ss_String:dateString];
            [query whereKey:@"updatedAt" greaterThan:date];
        }
        else{
            [query whereKey:@"text" containsString:token];
        }
    }
}

@end
