The first data set contains the following variables:
1) Record ID - the row number of each record;
2) Subject ID - the ID of subject for the given record;
All the other variables come from the accelerometer and gyroscope 3-axial raw signals, Jerk signals, and the signals with a Fast Fourier Transform (FFT) applied.
The set of variables that were estimated from these signals are mean values and standard deviations.

In order to obtain this data set, the following transformations were made:
1) activity labels were obtained from the activity labels data set;
2) subjects train data set was merged with the X train data set to obtain subject ID for each of the resulting record;
3) based on the ids in the activity train data set activity labels for the train data set were obtained and merged with the train data set obtained in the previous step;
4) only columns for mean values and standard deviations were left in the resulting train data set, the rest was removed (except for Subject ID AND Activity);
5) column names of the resulting train data set were transformed to be descriptive:
a) column names starting with 't' were changed to contain 'Time' at the beginning;
b) column names starting with 'f' were changed to contain 'Frequency' at the beginning;
c) the abbreviation 'Acc' in column names was changed to 'Accelerometer ';
d) the abbreviation 'Gyro' in column names was changed to 'Gyroscope ';
e) the abbreviation 'Body' in column names was changed to 'Body ';
f) the abbreviation 'Jerk' in column names was changed to 'Jerk ';
g) the abbreviation 'Mag' in column names was changed to 'Magnitude ';
h) the abbreviation '-mean()' in column names was changed to 'Mean';
i) the abbreviation '-std()' in column names was changed to 'Standard Deviation';
j) the abbreviation '-X' in column names was changed to ' (X Direction)';
k) the abbreviation '-Y' in column names was changed to ' (Y Direction)';
l) the abbreviation '-Z' in column names was changed to ' (Z Direction)';
6) steps 2 to 5 were repeated for the test data to obtain the resulting test data set;
7) the test data set was appended to the train data set to form the resulting first data set;
8) the 'Record ID' column was added at the beginning of the resulting first data set to have the row number of each record;
9) the resulting first data set was written to the 'df.1.txt' file with space as separator used.

In order to obtain the second data set, the following transformations were used:
1) the 'Record ID' column was removed as it is will be invalid in the new data set;
2) the resulting data set was grouped on the 'Subject ID' and 'Activity' columns and summarized on all the other columns using mean as the summary function;
8) the 'Record ID' column was added at the beginning of the resulting second data set to have the row number of each record;
9) the resulting second data set was written to the 'df.2.txt' file with space as separator used.

The column names in the resulting second data set are the same as the column names of the first data set.
