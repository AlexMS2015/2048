//
//  TwentyFourtyEightVC.m
//  2048
//
//  Created by Alex Smith on 18/10/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "TwentyFourtyEightVC.h"
#import "TwentyFourtyEight.h"
#import "NoScrollGridVC.h"

@interface TwentyFourtyEightVC ()

@property (strong, nonatomic) NoScrollGridVC *boardCVC;
@property (strong, nonatomic) TwentyFourtyEight *game;

// outlets
@property (weak, nonatomic) IBOutlet UICollectionView *boardView;

@end

@implementation TwentyFourtyEightVC

#pragma mark - Properties

-(void)setGame:(TwentyFourtyEight *)game
{
    _game = game;
    
    self.boardCVC = [[NoScrollGridVC alloc] initWithgridSize:self.game.board.size collectionView:self.boardView andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, int index) {
        cell.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        cell.contentView.layer.borderWidth = 0.5;
        NSNumber *valueAtCurrPos = [self.game.board objectAtPosition:position];
        UILabel *cellValueLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        cellValueLabel.textAlignment = NSTextAlignmentCenter;
        cellValueLabel.text = [valueAtCurrPos stringValue];
        [cell.contentView addSubview:cellValueLabel];
    } andCellTapHandler:^(UICollectionViewCell *cell, Position position, int index) {
        
    }];
}

#pragma mark - View Life Cycle

-(void)viewDidLoad
{
    self.game = [[TwentyFourtyEight alloc] initWithGameOfSize:(GridSize){4, 4}];
}

@end
