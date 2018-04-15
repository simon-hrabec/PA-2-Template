#ifndef TIME_MEASURE_H
#define TIME_MEASURE_H

#include <chrono>
#include <ratio>

using namespace std::chrono;

class timeMeasure {
	steady_clock::time_point lastTimestamp, initTimestamp;
public:
	enum class measureMode {
		lastInit, lastCall
	};

	timeMeasure();
	double measureSeconds(const measureMode mode = measureMode::lastCall);
	double measureSeconds(steady_clock::time_point fromTimestamp);
	void initTimer();
};

#endif /* end of include guard: TIME_MEASURE_H */