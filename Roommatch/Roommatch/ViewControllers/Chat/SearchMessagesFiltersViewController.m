//
//  SearchMessagesFiltersViewController.m
//  Roommatch
//
//  Created by Lily Yang on 8/3/22.
//

#import "SearchMessagesFiltersViewController.h"

@interface SearchMessagesFiltersViewController ()

@end

@implementation SearchMessagesFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFields];
}

- (void)setFields {
    self.fromButton.selected = self.filters.from;
    self.toButton.selected = self.filters.to;
    self.beforeButton.selected = self.filters.before;
    self.afterButton.selected = self.filters.after;
    
    self.fromTextField.text = self.filters.fromUsername;
    self.toTextField.text = self.filters.toUsername;
    self.beforeDatePicker.date = self.filters.beforeDate;
    self.beforeDatePicker.hidden = !self.filters.before;
    self.afterDatePicker.date = self.filters.afterDate;
    self.afterDatePicker.hidden = !self.filters.after;
}

- (IBAction)checkBefore:(UIButton *)sender {
    if(sender.selected){
        sender.selected = NO;
        self.beforeDatePicker.hidden = YES;
    }
    else{
        sender.selected = YES;
        self.beforeDatePicker.hidden = NO;
    }
}

- (IBAction)checkAfter:(UIButton *)sender {
    if(sender.selected){
        sender.selected = NO;
        self.afterDatePicker.hidden = YES;
    }
    else{
        sender.selected = YES;
        self.afterDatePicker.hidden = NO;
    }
}

- (IBAction)selectCheckbox:(UIButton *)sender {
    if(sender.selected)
        sender.selected = NO;
    else
        sender.selected = YES;
}

- (IBAction)saveFiltersButton:(id)sender {
    self.filters.from = self.fromButton.selected;
    self.filters.to = self.toButton.selected;
    self.filters.before = self.beforeButton.selected;
    self.filters.after = self.afterButton.selected;
    
    self.filters.fromUsername = self.fromTextField.text;
    self.filters.toUsername = self.toTextField.text;
    self.filters.beforeDate = self.beforeDatePicker.date;
    self.filters.afterDate = self.afterDatePicker.date;
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
