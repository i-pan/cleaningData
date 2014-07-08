CodeBook
========================================================

Taken from the features_info.txt in the data provided: 

>"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

>These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions."

Data Parsing
------------

    The raw data was parsed by extracting only the columns that contained measurements of "mean()" or "std()" values. Using a 1-to-1 correspondence between the columns and the features (provided in the original data), it was possible to assign each column to a specific type of measurement. Using the grep() function, we could find columns that measured the mean() or std() values. Note that we set the parameter fixed=T in order to prevent extracting columns containing the meanFreq() values. These values were not of interest to us because they were weighted averages of frequency measurements, rather than strict averages of the observations.

Prefix: t
---------

    Any variable with the prefix 't' refers to a time domain signal. Units are in seconds. 

Prefix: f
---------

    Any variable with the prefix 'f' refers to a frequency domain signal. Units are in Hz.
    
Suffix: XYZ
-----------

    As mentioned above, the '-XYZ' appendage refers to which direction the measurement pertains. 

Type: BodyAcc
-------------

    Any variable with 'BodyAcc' refers to the body's linear acceleration. 

Type: GyroAcc
-------------

    Any variable with 'GyroAcc' refers to the body's angular velocity.

Type: GravityAcc
----------------

    Any variable with 'GravityAcc' refers to the acceleration due to gravity.

Type: Jerk
----------

    Any variable with 'Jerk' refers to the time derivative of either the linear acceleration, BodyAcc, or the angular velocity, 'GyroAcc.'

Type: Mag
---------

    Any variable with 'Mag' refers to the magnitude of the 3D signals, calculated using Euclidean norm:

```{r}
sqrt(x^2+y^2+z^2)
```

Type: mean()
------------

    Any variable with 'mean()' refers to the mean measurement of that value.

Type: std()
-----------

    Any variable with 'std()' refers to the standard deviation measurement of the observations.

Type: AVERAGE
-------------

    Any variable with 'AVERAGE' refers to the average of all the values of that variable found in the dataset. These values were calculated using the mean() function in R. 

Example Interpretation
----------------------

    i.e. "tBodyAcc-mean()-Y AVERAGE" refers to the AVERAGE of the recorded means of the time domain signals measured in the Y direction for linear acceleration of the body for a particular subject-activity combination.

SubjectNumber
---------------

    The number of the subject. This ranges from 1 to 30. 
    
ActivityPerformed
-------------------

    The activity performed when the measurements were taken. There are 6 types of activities:
    
      WALKING: subject was walking on a flat surface
      
      WALKING UPSTAIRS: subject was walking up stairs
      
      WALKING DOWNSTAIRS: subject was walking down stairs
      
      SITTING: subject was sitting down, not moving
      
      STANDING: subject was standing up, not moving
      
      LAYING: subject was laying flat, not moving

Notes
-----

    Only the tidy data set contains the "AVERAGE" type values. The tidy dataset does not contain non-average values, but it does contain the SubjectNumber and ActivityPerformed. 
    
    The parsed, but not tidy, dataset does not contain the "AVERAGE" type values - but it contains every other type of value. 
