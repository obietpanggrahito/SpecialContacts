//
//  ViewController.m
//  contactList
//
//  Created by Obiet Panggrahito on 21/03/2017.
//  Copyright © 2017 Obiet Panggrahito. All rights reserved.
//

#import "ViewController.h"
                            //3
@interface ViewController () <UITableViewDataSource>

//1
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) NSMutableArray *phoneNumbers;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *edit;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //8
    [self prepareContacts];
    [self prepareTableView];
    
    //13
    [self prepareButtons];
    
}

//2
-(void) prepareTableView {
    
    self.tableView.dataSource = self;
    
}

//7
- (void)prepareContacts {
    
    self.contacts = [@[@"kim", @"rock", @"naruto"] mutableCopy]; //special for NSMutableArray if you use this array literal
    self.phoneNumbers = [@[@"113323", @"373873", @"38464"] mutableCopy];
    
}

// 11
-(void) prepareButtons {
    
    [self.buttonAdd addTarget:self action:@selector(addNewContacts) forControlEvents:UIControlEventTouchUpInside];
    
}

// 12
-(void) addNewContacts {
    
    UIAlertController *keyInDetails = [UIAlertController alertControllerWithTitle:@"Add Contact" message:@"Enter Details" preferredStyle:UIAlertControllerStyleAlert];
    
    [keyInDetails addTextFieldWithConfigurationHandler:^(UITextField* name) {
        name.placeholder = @"Name";
        name.textColor = [UIColor blackColor];
        name.clearButtonMode = UITextFieldViewModeWhileEditing;
        name.borderStyle = UITextBorderStyleRoundedRect;
     
     }];
        
    [keyInDetails addTextFieldWithConfigurationHandler:^(UITextField * phoneNumber) {
        phoneNumber.placeholder = @"Phone Number";
//        phoneNumber.textInputMode = int;
        phoneNumber.textColor = [UIColor blackColor];
        phoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneNumber.borderStyle = UITextBorderStyleRoundedRect;
        
    }];
    
    [keyInDetails addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    
    [keyInDetails addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSArray *textfields = keyInDetails.textFields;
        UITextField* nameField = textfields[0];
        UITextField* numberField = textfields[1];
        
        [self.contacts addObject:nameField.text];
        [self.phoneNumbers addObject:numberField.text];
        [self.tableView reloadData];

    }]];
    
    [self presentViewController:keyInDetails animated:YES completion:NULL];
    [self.textField resignFirstResponder];
    self.textField.text = @"";
    
}

//6 macro. help to navigate
#pragma mark - UITableView DataSource

//4
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     [self.textField resignFirstResponder];
    
            //9 how many rows
    return self.contacts.count;
    
}

//5
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
        //10 display name
        [cell.textLabel setText:self.contacts[indexPath.row]];
        [cell.detailTextLabel setText:self.phoneNumbers[indexPath.row]];
    
    return  cell;
    
}

//declare for delete and re-ordering
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//delete
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        // remove data from the array
        [self.contacts removeObjectAtIndex:indexPath.row];
        [self.phoneNumbers removeObjectAtIndex:indexPath.row];
       
        //remove row from the tableview
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

//re-order
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    return;
}


//for edit
- (IBAction)editButton:(id)sender {
    
    [self.tableView setEditing:!self.tableView.editing];
    if (self.tableView.editing) {
        [self.edit setTitle:@"Done"];
        [self.edit setTintColor:[UIColor redColor]];
    } else {
        [self.edit setTitle:@"Edit"];
        [self.edit setTintColor:[UIColor blueColor]];
    }
}

//swipeGesture
-(void)swipeCell:(UISwipeGestureRecognizer *) swiper {
    
    CGPoint location = [swiper locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    UITableViewCell *swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
    [swipedCell.textLabel setTextColor:[UIColor redColor]];
    
}


// swipeGesture
- (IBAction)swipeGesture:(id)sender {
    
    [self swipeCell:sender];
    
}

/* To improve
    1.  when there is already a name in the textfield, then you press the add button, the nameField should be autofill
    2.  when there is no name or no phone number in the nameField or numberField, there should be an alert
    3.  autohide keyboards when the user is not typing
    4.  swipe again go clear
*/
 
@end
