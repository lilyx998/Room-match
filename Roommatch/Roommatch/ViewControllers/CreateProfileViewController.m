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

@interface CreateProfileViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *pronounsTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

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
    // Do any additional setup after loading the view.
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



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
