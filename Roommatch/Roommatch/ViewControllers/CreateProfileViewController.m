//
//  CreateProfileViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/8/22.
//

#import "CreateProfileViewController.h"
#import "Lib.h"
#import "User.h"
#import <Parse/Parse.h>
@import AutoCompletion;
#import "GeoDBManager.h"

@interface CreateProfileViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *pronounsTextField;
//@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet AutoCompletionTextField *cityTextField;
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
@property int charLimit;

@end

@implementation CreateProfileViewController

- (void)viewDidLoad {
    self.charLimit = 280; 
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    self.bioTextView.delegate = self;
    
    self.cityTextField.suggestionsResultDataSource = [GeoDBManager new];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    if(![User currentUser]){
        [self dismissViewControllerAnimated:YES completion:nil];
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
        [Lib alertViewController:self WithMessage:@"Please fill out all required fields"];
        return;
    }
    
    User* user = [User currentUser];
    user.name = self.nameTextField.text;
    user.age = self.ageTextField.text;
    user.pronouns = self.pronounsTextField.text;
    user.profilePicture = [Lib getPFFileFromImage:self.imageView.image];
    user.priceLow = self.priceLow.text;
    user.priceHigh = self.priceHigh.text;
    user.city = self.cityTextField.text;
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
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
        if(error)
            [Lib alertViewController:self WithMessage:error.localizedDescription];
        else{
            [self performSegueWithIdentifier:@"Create Profile Segue" sender:nil];
        }
    }];
}

- (BOOL)areRequiredFeaturesFilled {
    if(!self.choseImage
       || [self.nameTextField.text isEqualToString:@""]
       || [self.ageTextField.text isEqualToString:@""]
       || [self.cityTextField.text isEqualToString:@""]
       || [self.bioTextView.text isEqualToString:@""]
       || [self.instagramTagTextField.text isEqualToString:@""]){
        return NO;
    }
    return YES;
}

-(void)hideKeyboard {
    [self.view endEditing:YES];
}

// shouldChangeTextInRange is called every
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if(newText.length <= self.charLimit){
        NSInteger remaining = self.charLimit - newText.length;
        self.charactersRemainingLabel.text = [@(remaining) stringValue];
        [self.charactersRemainingLabel setTextColor:[UIColor colorWithDisplayP3Red:0 green:0.5 blue:0.194 alpha:100]];
        if(remaining == 0)
           [self.charactersRemainingLabel setTextColor:[UIColor redColor]];
    }
    
    return newText.length <= self.charLimit;
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
