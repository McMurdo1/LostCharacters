//
//  CharacterDetailViewController.m
//  LostCharacters
//
//  Created by Matthew Graham on 1/28/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "AddCharacterViewController.h"
#import "Characters.h"

@interface AddCharacterViewController () <UIAlertViewDelegate>
{
    __weak IBOutlet UITextField *passengerNameTextField;
    __weak IBOutlet UITextField *actorTextField;
    __weak IBOutlet UITextField *numEpisodesTextField;
    __weak IBOutlet UITextField *startYearTextField;
    __weak IBOutlet UITextField *endYearTextField;
    
}

@end

@implementation AddCharacterViewController

@synthesize detailManagedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dharma.png"]];
}

- (IBAction)onCommitButtonPressed:(id)sender
{
    Characters *newCharacter = [NSEntityDescription insertNewObjectForEntityForName:@"Characters" inManagedObjectContext:detailManagedObjectContext];
    newCharacter.passenger = passengerNameTextField.text;
    newCharacter.actor = actorTextField.text;
    newCharacter.numEpisodes = numEpisodesTextField.text;
    newCharacter.startYear = startYearTextField.text;
    newCharacter.endYear = endYearTextField.text;
    [detailManagedObjectContext save:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Character Added" message:@"Thanks!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        passengerNameTextField.text = nil;
        actorTextField.text = nil;
        numEpisodesTextField.text = nil;
        startYearTextField.text = nil;
        endYearTextField.text = nil;
    }
}


@end
