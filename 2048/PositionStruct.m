
#import "PositionStruct.h"

BOOL PositionsAreAdjacent(Position pos1, Position pos2)
{
    if (abs(pos1.row - pos2.row) <= 1 && abs(pos1.column - pos2.column) <= 1) {
        return (pos1.row == pos2.row) ^ (pos1.column == pos2.column);
    }
    
    return NO;
}

BOOL PositionsAreEqual(Position pos1, Position pos2)
{
    return pos1.row == pos2.row && pos1.column == pos2.column;
}
