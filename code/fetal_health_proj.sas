/************************************************************
PROJECT: Fetal Health Classification using CTG Data
AUTHOR: Your Name
DATE: February 2026
PURPOSE: Predict fetal health status (Normal/Suspect/Pathological)
         using cardiotocogram features
************************************************************/

/* ================================================
   SECTION 1: DATA IMPORT AND EXPLORATION
   ================================================ */

/* Import the CSV file */
PROC IMPORT DATAFILE="/home/u64317563/fetal_health.csv"
    OUT=fetal_raw
    DBMS=CSV
    REPLACE;
    GETNAMES=YES;
RUN;

/* View first 20 observations */
TITLE "First 20 Observations";
PROC PRINT DATA=fetal_raw(OBS=20);
RUN;

/* Check variable names and types */
TITLE "Dataset Structure";
PROC CONTENTS DATA=fetal_raw;
RUN;

/* Get basic statistics */
TITLE "Summary Statistics - All Variables";
PROC MEANS DATA=fetal_raw N NMISS MEAN STD MIN MAX;
RUN;

/* Check class distribution */
TITLE "Fetal Health Status Distribution";
PROC FREQ DATA=fetal_raw;
    TABLES fetal_health;
RUN;

/* ================================================
   SECTION 2: DATA CLEANING AND PREPARATION
   ================================================ */

DATA fetal_clean;
    SET fetal_raw;
    
    /* Create categorical health status */
    LENGTH health_status $15;
    IF fetal_health = 1 THEN health_status = 'Normal';
    ELSE IF fetal_health = 2 THEN health_status = 'Suspect';
    ELSE IF fetal_health = 3 THEN health_status = 'Pathological';
    
    /* Create binary outcome: Abnormal vs Normal */
    IF fetal_health = 1 THEN abnormal = 0;
    ELSE abnormal = 1;
    
    /* Label variables for better output */
    LABEL 
        baseline_value = "Baseline Fetal Heart Rate"
        accelerations = "Number of Accelerations"
        fetal_movement = "Fetal Movement"
        uterine_contractions = "Uterine Contractions"
        light_decelerations = "Light Decelerations"
        severe_decelerations = "Severe Decelerations"
        prolongued_decelerations = "Prolonged Decelerations"
        health_status = "Fetal Health Status"
        abnormal = "Abnormal (Suspect or Pathological)";
RUN;

/* Verify cleaning */
TITLE "Cleaned Data - First 10 Rows";
PROC PRINT DATA=fetal_clean(OBS=10);
    VAR baseline_value accelerations health_status abnormal;
RUN;

/* Check for missing values */
TITLE "Missing Data Check";
PROC MEANS DATA=fetal_clean NMISS;
RUN;

/* ================================================
   SECTION 3: DESCRIPTIVE STATISTICS
   ================================================ */

/* Table 1: Overall statistics by health status */
TITLE "Table 1: Descriptive Statistics by Fetal Health Status";
PROC MEANS DATA=fetal_clean N MEAN STD MIN MAX MAXDEC=2;
    CLASS health_status;
    VAR baseline_value accelerations fetal_movement 
        uterine_contractions severe_decelerations;
RUN;

/* Frequency table */
TITLE "Frequency Distribution of Fetal Health Status";
PROC FREQ DATA=fetal_clean;
    TABLES health_status / NOCUM PLOTS=FREQPLOT;
RUN;

/* Crosstabulation */
TITLE "Severe Decelerations by Health Status";
PROC FREQ DATA=fetal_clean;
    TABLES health_status*severe_decelerations / CHISQ;
RUN;


/* ================================================
   SECTION 4: VISUALIZATIONS
   ================================================ */

/* Histogram of baseline heart rate */
TITLE "Distribution of Baseline Fetal Heart Rate";
PROC SGPLOT DATA=fetal_clean;
    HISTOGRAM baseline_value;
    DENSITY baseline_value;
    XAXIS LABEL="Baseline FHR (bpm)";
    YAXIS LABEL="Frequency";
RUN;

/* Box plot: Baseline FHR by health status */
TITLE "Baseline FHR by Fetal Health Status";
PROC SGPLOT DATA=fetal_clean;
    VBOX baseline_value / CATEGORY=health_status;
    XAXIS LABEL="Health Status";
    YAXIS LABEL="Baseline FHR (bpm)";
RUN;

/* Scatter plot: Accelerations vs Baseline */
TITLE "Accelerations vs Baseline FHR by Health Status";
PROC SGPLOT DATA=fetal_clean;
    SCATTER X=baseline_value Y=accelerations / GROUP=health_status;
    XAXIS LABEL="Baseline FHR (bpm)";
    YAXIS LABEL="Number of Accelerations";
RUN;

/* Bar chart of health status */
TITLE "Distribution of Fetal Health Status";
PROC SGPLOT DATA=fetal_clean;
    VBAR health_status / STAT=FREQ DATALABEL;
    XAXIS LABEL="Health Status";
    YAXIS LABEL="Count";
RUN;


/* ================================================
   SECTION 5: BINARY LOGISTIC REGRESSION
   (Abnormal vs Normal)
   ================================================ */

TITLE "Binary Logistic Regression: Abnormal vs Normal";
PROC LOGISTIC DATA=fetal_clean DESCENDING;
    MODEL abnormal = baseline_value accelerations fetal_movement
                     uterine_contractions severe_decelerations
                     / LACKFIT RSQUARE;
    OUTPUT OUT=pred_binary PREDICTED=pred_prob;
RUN;

/* ROC Curve for binary model */
TITLE "ROC Curve - Binary Classification";
PROC LOGISTIC DATA=fetal_clean DESCENDING PLOTS=ROC;
    MODEL abnormal = baseline_value accelerations severe_decelerations;
RUN;


/* ================================================
   SECTION 6: MULTINOMIAL LOGISTIC REGRESSION
   (3 classes: Normal, Suspect, Pathological)
   ================================================ */

TITLE "Multinomial Logistic Regression: 3-Class Prediction";
PROC LOGISTIC DATA=fetal_clean;
    CLASS health_status(REF='Normal') / PARAM=REF;
    MODEL health_status = baseline_value accelerations fetal_movement
                         uterine_contractions severe_decelerations
                         prolongued_decelerations;
    OUTPUT OUT=pred_multi PREDICTED=pred_class PREDPROBS=INDIVIDUAL;
RUN;


/* ================================================
   SECTION 7: MODEL EVALUATION
   ================================================ */

/* Confusion Matrix - Binary Model */
TITLE "Confusion Matrix - Binary Classification";
DATA pred_binary_class;
    SET pred_binary;
    IF pred_prob >= 0.5 THEN predicted = 1;
    ELSE predicted = 0;
RUN;

PROC FREQ DATA=pred_binary_class;
    TABLES abnormal*predicted / NOCOL NOPERCENT;
RUN;

/* Calculate accuracy */
PROC SQL;
    SELECT 
        SUM(abnormal = predicted) / COUNT(*) AS Accuracy FORMAT=PERCENT8.2,
        SUM(abnormal = 1 AND predicted = 1) / SUM(abnormal = 1) AS Sensitivity FORMAT=PERCENT8.2,
        SUM(abnormal = 0 AND predicted = 0) / SUM(abnormal = 0) AS Specificity FORMAT=PERCENT8.2
    FROM pred_binary_class;
QUIT;


/* ================================================
   SECTION 8: VARIABLE SELECTION
   ================================================ */

/* Stepwise variable selection */
TITLE "Stepwise Variable Selection";
PROC LOGISTIC DATA=fetal_clean DESCENDING;
    MODEL abnormal = baseline_value accelerations fetal_movement
                     uterine_contractions light_decelerations 
                     severe_decelerations prolongued_decelerations
                     / SELECTION=STEPWISE SLS=0.05 SLE=0.05;
RUN;


/* ================================================
   SECTION 9: CORRELATION ANALYSIS
   ================================================ */

TITLE "Correlation Matrix of Key Variables";
PROC CORR DATA=fetal_clean PLOTS=MATRIX;
    VAR baseline_value accelerations fetal_movement 
        severe_decelerations abnormal;
RUN;


/* ================================================
   SECTION 10: EXPORT RESULTS
   ================================================ */

/* Export predictions to CSV */
PROC EXPORT DATA=pred_binary
    OUTFILE="/home/u64317563/predictions_binary.csv"
    DBMS=CSV
    REPLACE;
RUN;

/* Export summary statistics */
PROC MEANS DATA=fetal_clean NOPRINT;
    CLASS health_status;
    VAR baseline_value accelerations severe_decelerations;
    OUTPUT OUT=summary_stats MEAN=mean_baseline mean_accel mean_severe;
RUN;

PROC EXPORT DATA=summary_stats
    OUTFILE="/home/u64317563/summary_statistics.csv"
    DBMS=CSV
    REPLACE;
RUN;


/* ================================================
   END OF PROGRAM
   ================================================ */
