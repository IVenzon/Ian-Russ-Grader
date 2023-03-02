# CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
CPATH=".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -f ListExamples.java ]]
then
    echo 'Correct file found'
else
    echo 'Need ListExamples.java'
    exit
fi

cp ListExamples.java ..
cd ..


rm -rf testing-folder
mkdir testing-folder

cp TestListExamples.java testing-folder
cp ListExamples.java testing-folder
cp -r lib testing-folder

echo 'Files ready for testing'

javac -cp $CPATH ./testing-folder/*.java 2> compile-result.txt

X=$?

echo $X


if [[ $X -eq 0 ]]
then
    echo 'Compiled successfully'
else
    echo 'Errors were found while compiling'
    echo 'Error code is: ' $X
    exit
fi


cd testing-folder

# java -cp $CPATH org.junit.runner.JUnitCore ./testing-folder/TestListExamples > run-result.txt
java -cp ".;lib/junit-4.13.2.jar;lib/hamcrest-core-1.3.jar" org.junit.runner.JUnitCore TestListExamples > run-result.txt

cp run-result.txt ..

cd ..

X=$?

if [[ $X -eq 0 ]]
then
    echo 'Ran successfully'
else
    echo 'Errors were found while running'
    echo 'Error code is: ' $X
    exit
fi

rm -rf failures.txt 

grep -c -i "FAILURES" run-result.txt > failures.txt


fails=`grep -c -i "FAILURES" run-result.txt`

echo "-----"

if [[ $fails -eq 0 ]]
then
    echo "You passed!"
else
    echo "We found an error, so you fail!"
fi