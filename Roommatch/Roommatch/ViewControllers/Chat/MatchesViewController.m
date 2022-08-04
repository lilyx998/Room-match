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
#import "SearchMessagesFiltersViewController.h"
#import "SearchFilters.h"

@interface MatchesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chatsTableView;
@property (strong, nonatomic) NSMutableArray *chatsToDisplay;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchMessagesTableView;
@property (strong, nonatomic) NSMutableArray *searchMessages;
@property (strong, nonatomic) SearchFilters *filters; 

@end

@implementation MatchesViewController


#pragma mark - View initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryAndDisplayChats) forControlEvents:UIControlEventValueChanged];
    [self.chatsTableView addSubview:self.refreshControl];
    
    self.filters = [[SearchFilters alloc] init];
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
    [query orderByDescending:@"lastMessageDate"];
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


#pragma mark - Table view of Chats

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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.chatsTableView)
        return self.chatsToDisplay.count;
    return self.searchMessages.count;
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


#pragma mark - Search bar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchMessagesTableView.hidden = NO;
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchMessagesTableView.hidden = YES;
    searchBar.showsCancelButton = NO;
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
    
    [self addFiltersToQuery:query];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.searchMessages = [NSMutableArray arrayWithArray:objects];
        [self.searchMessagesTableView reloadData];
    }];
}

- (void)addFiltersToQuery:(PFQuery *)query {
    if(self.filters.from){
        User *user = [User getUserFromUsername:self.filters.fromUsername];
        if(user)
            [query whereKey:@"fromUser" equalTo:user];
    }
    if(self.filters.to){
        User *user = [User getUserFromUsername:self.filters.toUsername];
        if(user)
            [query whereKey:@"toUser" equalTo:user];
    }
    if(self.filters.before){
        [query whereKey:@"updatedAt" lessThanOrEqualTo:self.filters.beforeDate];
    }
    if(self.filters.after){
        [query whereKey:@"updatedAt" greaterThanOrEqualTo:self.filters.afterDate];
    }
    
    NSArray *words = [self.searchBar.text componentsSeparatedByString:@" "];
    for(NSString *word in words)
        [query whereKey:@"text" containsString:word];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"searchFiltersSegue"]){
        SearchMessagesFiltersViewController *filtersVC = [segue destinationViewController];
        filtersVC.filters = self.filters;
        return;
    }
    NSIndexPath *indexPath = [self.chatsTableView indexPathForSelectedRow];
    
    Chat *chatToPass = self.chatsToDisplay[indexPath.row];
    MessagesViewController *messagesVC = [segue destinationViewController];
    messagesVC.chat = chatToPass;
}

@end
