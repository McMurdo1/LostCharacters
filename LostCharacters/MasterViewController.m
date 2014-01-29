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
    __weak IBOutlet UITableView *charactersTableView;
    __weak IBOutlet UITextField *searchTextField;

}

@end

@implementation MasterViewController
@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"First Run"])
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
//    if (searchTextField.text)
//    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"passenger CONTAINS[cd]%@",searchTextField.text];
//        request.predicate = predicate;
//    }

    characters = [managedObjectContext executeFetchRequest:request error:nil];
    [charactersTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return characters.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Characters *character = [characters objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReuseIdentifier"];
    cell.textLabel.text = character.passenger;
    cell.detailTextLabel.text = character.actor;
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"AddCharacterSegue"])
    {
        NSLog(@"Segue Identifier is %@",segue.identifier);
        AddCharacterViewController *acvc = segue.destinationViewController;
        acvc.detailManagedObjectContext = self.managedObjectContext;
    }
    if ([segue.identifier isEqualToString:@"CharacterDetailSegue"])
    {
        NSLog(@"The Segue Identifier is %@", segue.identifier);
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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Characters"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"passenger" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
        if (searchTextField.text)
    {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"passenger CONTAINS[cd]%@",searchTextField.text];
            request.predicate = predicate;
    }
    
    characters = [managedObjectContext executeFetchRequest:request error:nil];
    [charactersTableView reloadData];
    return YES;
}

@end
