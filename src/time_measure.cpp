#include <chrono>
#include <ratio>
#include "../headers/time_measure.h"

using namespace std::chrono;

timeMeasure::timeMeasure(){
	lastTimestamp = std::chrono::steady_clock::now();
}

double timeMeasure::measureSeconds(const measureMode mode /*= measureMode::lastCall*/){ //TODO this method cause a compilation warning
	switch (mode) {
	case measureMode::lastCall :
		return measureSeconds(lastTimestamp);
	case measureMode::lastInit :
		return measureSeconds(initTimestamp);
	}
}

double timeMeasure::measureSeconds(const steady_clock::time_point fromTimestamp){
	steady_clock::time_point newTimestamp = steady_clock::now();
	lastTimestamp = newTimestamp;
	return duration_cast<duration<double> >(newTimestamp - fromTimestamp).count();
}

void timeMeasure::initTimer(){
	initTimestamp = lastTimestamp = steady_clock::now();
}
