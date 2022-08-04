//
//  PreferencesViewController.m
//  Roommatch
//
//  Created by Lily Yang on 8/1/22.
//

#import "PreferencesViewController.h"
#import "User.h"

@interface PreferencesViewController ()

@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *nonbinaryButton;

@property (weak, nonatomic) IBOutlet UIButton *dogButton;
@property (weak, nonatomic) IBOutlet UIButton *catButton;
@property (weak, nonatomic) IBOutlet UIButton *otherPetsButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *collegePreferencesSegementedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *smokingPreferencesSegmentedControl;

@end

@implementation PreferencesViewController


#pragma mark - View initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFields];
    // Do any additional setup after loading the view.
}

- (void)setFields {
    User *curUser = [User currentUser];
    
    self.maleButton.selected = curUser.preferenceMale;
    self.femaleButton.selected = curUser.preferenceFemale;
    self.nonbinaryButton.selected = curUser.preferenceNonbinary;
    
    self.dogButton.selected = curUser.preferenceDogs;
    self.catButton.selected = curUser.preferenceCats;
    self.otherPetsButton.selected = curUser.preferenceOtherPets;
    
    self.collegePreferencesSegementedControl.selectedSegmentIndex = (curUser.preferenceCollege ? 1 : 0);
    self.smokingPreferencesSegmentedControl.selectedSegmentIndex = (curUser.preferenceSmoking ? 0 : 1);
}


#pragma mark - Handle user input 

- (IBAction)selectCheckbox:(UIButton *)sender {
    if(sender.selected)
        sender.selected = NO;
    else
        sender.selected = YES;
}

- (IBAction)tapDone:(id)sender {
    User *curUser = [User currentUser];
    curUser.preferenceMale = self.maleButton.selected;
    curUser.preferenceFemale = self.femaleButton.selected;
    curUser.preferenceNonbinary = self.nonbinaryButton.selected;
    
    curUser.preferenceDogs = self.dogButton.selected;
    curUser.preferenceCats = self.catButton.selected;
    curUser.preferenceOtherPets = self.otherPetsButton.selected;
    
    curUser.preferenceCollege = (self.collegePreferencesSegementedControl.selectedSegmentIndex == 1);
    curUser.preferenceSmoking = (self.smokingPreferencesSegmentedControl.selectedSegmentIndex == 0);
    [curUser saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
