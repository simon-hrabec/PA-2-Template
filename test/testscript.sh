#!/bin/bash
inputDir=test/input/
outputDir=test/output/
expectedDir=test/expected/

testFiles=$(ls $inputDir)

rm -r "$outputDir"
mkdir -p "$outputDir"

passedTests=0
failedTests=0

for file in $testFiles
do
	./bin/squares < "$inputDir$file" > "$outputDir$file"
	if diff "$outputDir$file" "$expectedDir$file"
	then
		echo "Test $file passed"
		passedTests=$((passedTests+1))
	else
		echo "Test $file failed"
		failedTests=$((failedTests+1))
	fi
done

totalTests=$((passedTests+failedTests))
echo "Passed $passedTests/$totalTests tests"

if [[ failedTests -gt 0 ]]
then
	exit 1	
fi
