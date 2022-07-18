//
//  DiscoverViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/18/22.
//

#import "DiscoverViewController.h"
#import "ProfileCell.h"
#import <Parse/Parse.h>
#import "User.h"

@interface DiscoverViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *usersToDisplay;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   self.usersToDisplay = [NSMutableArray array];
   [self queryUsersToDisplay];
   self.tableView.dataSource = self;
   
   [self.tableView reloadData];
   
   
   // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   // Get the new view controller using [segue destinationViewController].
   // Pass the selected object to the new view controller.
}
*/

- (void)queryUsersToDisplay {
   PFQuery *query = [User query];
   
   [query whereKey:@"usersSeen" notEqualTo:[User currentUser].objectId];
   [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
       if (users) {
           NSLog(@"%@", [@(users.count) stringValue]);
           for(PFObject* user in users){
               [self.usersToDisplay addObject:user];
           }
           [self.tableView reloadData];
       } else {
           NSLog(@"%@", error.localizedDescription);
       }
   }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
   ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
   
   User* user = self.usersToDisplay[indexPath.row];
   [cell initWithUserObject:user];
   
   return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.usersToDisplay.count;
}

@end
