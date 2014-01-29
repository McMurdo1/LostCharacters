//
//  ViewController.m
//  LostCharacters
//
//  Created by Matthew Graham on 1/28/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "MasterViewController.h"
#import "Characters.h"
#import "AddCharacterViewController.h"
#import "CharacterDetailViewController.h"
@import CoreData;


@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *lostCharactersArray;
    NSArray *characters;
    NSMutableArray *filteredCharacters;
    
    __weak IBOutlet UITableView *charactersTableView;
    __weak IBOutlet UITextField *searchTextField;
    
    BOOL isFiltered;

}

@end

@implementation MasterViewController
@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];

    searchTextField.delegate = self; // Set search bar delegate, used for filtering results
    isFiltered = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"First Run"]) // Check if this is the initial app load
    {
        // First run; call initial load function
        [self initialLoad];
        [userDefaults setObject:[NSDate date] forKey:@"First Run"];
        [userDefaults synchronize];
    }
    [self reload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self reload];
}

-(void)initialLoad
{
    lostCharactersArray = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/2/lost.plist"]];
    
    for (NSDictionary *lostCharacter in lostCharactersArray)
    {
        Characters *object = [NSEntityDescription insertNewObjectForEntityForName:@"Characters" inManagedObjectContext:managedObjectContext];
        object.actor = [lostCharacter objectForKey:@"actor"];
        object.passenger = [lostCharacter objectForKey:@"passenger"];
        [managedObjectContext save:nil];
    }
    [self reload];
}

-(void)reload
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Characters"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"passenger" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    characters = [managedObjectContext executeFetchRequest:request error:nil];
    [charactersTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltered == NO)
    {
        return characters.count;
    }
    else
    {
        return filteredCharacters.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Characters *character;
    if (isFiltered == NO)
    {
        character = [characters objectAtIndex:indexPath.row];
    }
    else
    {
        character = [filteredCharacters objectAtIndex:indexPath.row];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReuseIdentifier"];
    cell.textLabel.text = character.passenger;
    cell.detailTextLabel.text = character.actor;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"AddCharacterSegue"])
    {
        AddCharacterViewController *acvc = segue.destinationViewController;
        acvc.detailManagedObjectContext = self.managedObjectContext;
    }
    if ([segue.identifier isEqualToString:@"CharacterDetailSegue"])
    {
        CharacterDetailViewController *dcvc = segue.destinationViewController;
        NSIndexPath *indexPath = [charactersTableView indexPathForSelectedRow];
        dcvc.detailedCharacter = [characters objectAtIndex:indexPath.row];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [managedObjectContext deleteObject:[characters objectAtIndex:indexPath.row]];
        [managedObjectContext save:nil];
        [self reload];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Smoke Monster";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        filteredCharacters = [NSMutableArray new];
        for (Characters *filteredCharacter in characters) {
            NSRange passengerRange = [filteredCharacter.passenger rangeOfString:textField.text options:NSCaseInsensitiveSearch];
            if (passengerRange.location != NSNotFound)
            {
                [filteredCharacters addObject:filteredCharacter];
            }
        }
    }
    [charactersTableView reloadData];
    [textField resignFirstResponder];
    return YES;
}

@end
