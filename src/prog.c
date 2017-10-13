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
	Point p1;
	printf("%d\n", isSquare(p1,p1,p1,p1));
	return 0;
}