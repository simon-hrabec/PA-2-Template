#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

typedef struct Point{
	int x,y;
} Point;

bool isSquare(Point p1, Point p2, Point p3, Point p4){
	return true;
}

int main(int argc, char const *argv[])
{
	const int pointCount = 4;
	Point pArr[pointCount];

	// Load 4 points
	for(int i = 0; i < pointCount; i++){
		if (scanf("%d", &pArr[i].x) != 1 ||
			scanf("%d",&pArr[i].y) != 1) {
			printf("Error loading numbers");
			return 0;
		}
	}

	// Check whether they form a square
	if (isSquare(pArr[0], pArr[1], pArr[2], pArr[3])){
		printf("Square\n");
	} else {
		printf("Not a square\n");
	}

	return 0;
}