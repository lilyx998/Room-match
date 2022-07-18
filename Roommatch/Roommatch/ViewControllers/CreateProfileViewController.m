//
//  CreateProfileViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/8/22.
//

#import "CreateProfileViewController.h"
#import "Utils.h"
#import "User.h"
#import <Parse/Parse.h>
@import AutoCompletion;
@import Parse;

static const int charLimit = 280;

@interface CreateProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *pronounsTextField;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceLow;
@property (weak, nonatomic) IBOutlet UITextField *priceHigh;

@property (weak, nonatomic) IBOutlet UILabel *charactersRemainingLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *smokingSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *petsSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inCollegeSegmentedControl;

@property (weak, nonatomic) IBOutlet UITextField *collegeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *instagramTagTextField;

@property (nonatomic) BOOL choseImage;

@end

@implementation CreateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    self.bioTextView.delegate = self;
}

- (void)setFields:(User *)user {
    self.nameTextField.text = user.name;
    self.ageTextField.text = user.age;
    self.pronounsTextField.text = user.pronouns;
    self.priceLow.text = user.priceLow;
    self.priceHigh.text = user.priceHigh;
    self.bioTextView.text = user.bio;
    self.charactersRemainingLabel.text = [@(charLimit - user.bio.length) stringValue];
    
    self.imageView.file = user.profilePicture;
    [self.imageView loadInBackground];
    
    if([user.smoking isEqualToString:@"No"])
        [self.smokingSegmentedControl setSelectedSegmentIndex:0];
    else if([user.smoking isEqualToString:@"Sometimes"])
        [self.smokingSegmentedControl setSelectedSegmentIndex:1];
    else
        [self.smokingSegmentedControl setSelectedSegmentIndex:2];
    
    if([user.pets isEqualToString:@"No"])
        [self.petsSegmentedControl setSelectedSegmentIndex:0];
    else if([user.pets isEqualToString:@"Dog(s)"])
        [self.petsSegmentedControl setSelectedSegmentIndex:1];
    else if([user.pets isEqualToString:@"Cat(s)"])
        [self.petsSegmentedControl setSelectedSegmentIndex:2];
    else if([user.pets isEqualToString:@"Dog(s) and cat(s)"])
        [self.petsSegmentedControl setSelectedSegmentIndex:3];
    else
        [self.petsSegmentedControl setSelectedSegmentIndex:4];
    
    if([user.inCollege isEqualToString:@"No"])
        [self.inCollegeSegmentedControl setSelectedSegmentIndex:0];
    else
        [self.inCollegeSegmentedControl setSelectedSegmentIndex:1];
    
    self.collegeNameTextField.text = user.collegeName;
    self.instagramTagTextField.text = user.instagramTag;
}

- (void)viewWillAppear:(BOOL)animated {
    User *user = [User currentUser];
    if(!user){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if(user.profileCreated){
        [self setFields:user];
        self.choseImage = YES;
    }
}

- (IBAction)chooseImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.choseImage = YES;
}

- (IBAction)tapDoneButton:(id)sender {
    if(![self areRequiredFeaturesFilled]){
        [Utils alertViewController:self WithMessage:@"Please fill out all required fields"];
        return;
    }
    
    User* user = [User currentUser];
    user.name = self.nameTextField.text;
    user.age = self.ageTextField.text;
    user.pronouns = self.pronounsTextField.text;
    user.profilePicture = [Utils getPFFileFromImage:self.imageView.image];
    user.priceLow = self.priceLow.text;
    user.priceHigh = self.priceHigh.text;
    user.bio = self.bioTextView.text;
    
    NSInteger smokingIndex = [self.smokingSegmentedControl selectedSegmentIndex];
    user.smoking = smokingIndex == 0 ? @"No" : (smokingIndex == 1 ? @"Sometimes" : @"Yes");
    
    NSInteger petsIndex = [self.petsSegmentedControl selectedSegmentIndex];
    NSArray *petsStatuses = @[@"No", @"Dog(s)", @"Cat(s)", @"Dog(s) and cat(s)", @"Other"];
    user.pets = petsStatuses[petsIndex];
    
    
    NSInteger inCollegeIndex = [self.inCollegeSegmentedControl selectedSegmentIndex];
    user.inCollege = inCollegeIndex == 0 ? @"No" : @"Yes";
    
    user.collegeName = self.collegeNameTextField.text;
    user.instagramTag = self.instagramTagTextField.text;
    user.profileCreated = YES; 
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
        if(error)
            [Utils alertViewController:self WithMessage:error.localizedDescription];
        else{
            [self performSegueWithIdentifier:@"Create Profile Segue" sender:nil];
        }
    }];
}

- (BOOL)areRequiredFeaturesFilled {
    if(!self.choseImage
       || [self.nameTextField.text isEqualToString:@""]
       || [self.ageTextField.text isEqualToString:@""]
       || [self.bioTextView.text isEqualToString:@""]
       || [self.instagramTagTextField.text isEqualToString:@""]){
        return NO;
    }
    return YES;
}

-(void)hideKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if(newText.length <= charLimit){
        NSInteger remaining = charLimit - newText.length;
        self.charactersRemainingLabel.text = [@(remaining) stringValue];
        [self.charactersRemainingLabel setTextColor:[UIColor colorWithDisplayP3Red:0 green:0.5 blue:0.194 alpha:100]];
        if(remaining == 0)
           [self.charactersRemainingLabel setTextColor:[UIColor redColor]];
    }
    
    return newText.length <= charLimit;
}

@end
