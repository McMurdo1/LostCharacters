//
//  CharacterDetailViewController.m
//  LostCharacters
//
//  Created by Matthew Graham on 1/28/14.
//  Copyright (c) 2014 Matthew Graham. All rights reserved.
//

#import "CharacterDetailViewController.h"

@interface CharacterDetailViewController ()
{
    __weak IBOutlet UILabel *passengerTextLabel;
    __weak IBOutlet UILabel *actorTextLabel;
    __weak IBOutlet UILabel *startDateTextLabel;
    __weak IBOutlet UILabel *endDateTextLabel;
    __weak IBOutlet UILabel *numEpisodesTextLabel;
    
}

@end

@implementation CharacterDetailViewController
@synthesize detailedCharacter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    passengerTextLabel.text = detailedCharacter.passenger;
    actorTextLabel.text = detailedCharacter.actor;
    startDateTextLabel.text = detailedCharacter.startYear;
    endDateTextLabel.text = detailedCharacter.endYear;
    numEpisodesTextLabel.text = detailedCharacter.numEpisodes;
}



@end
