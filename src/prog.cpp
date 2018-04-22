#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "../headers/time_measure.h"

#include <iostream>
using namespace std;

typedef struct Point{
	int x,y;
} Point;

bool isSquare(Point topLeft, Point topRight, Point bottomLeft, Point bottomRight){
	const bool straightLinesHorizontal = (topLeft.x == topRight.x && bottomLeft.x == bottomRight.x);
	const bool straightLinesVertical = (topLeft.y == bottomLeft.y && topRight.y == bottomRight.y);
	const bool pointsDoNotOverlap = (topLeft.y != topRight.y && topLeft.x != bottomLeft.x);
	return straightLinesHorizontal && straightLinesVertical && pointsDoNotOverlap;
}

int main(int argc, char const *argv[])
{
	timeMeasure time;
	const int pointCount = 4;
	Point pArr[pointCount];

	// Load 4 points
	for(int i = 0; i < pointCount; i++){
		if (scanf("%d", &pArr[i].x) != 1 ||
			scanf("%d",&pArr[i].y) != 1) {
			printf("Error loading numbers\n");
			return 0;
		}
	}

	// Check whether they form a square
	if (isSquare(pArr[0], pArr[1], pArr[2], pArr[3])){
		printf("Square\n");
	} else {
		printf("Not a square\n");
	}

	double elapsedTime = time.measureSeconds();
	//printf("%lf\n", elapsedTime);
	return 0;
}
