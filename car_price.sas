/* STEP 1: IMPORT THE DATA */

PROC IMPORT DATAFILE="/home/u64511498/sasuser.v94/car_price.csv"
    OUT=cars_raw
    DBMS=CSV
    REPLACE;
    GETNAMES=YES;
RUN;

PROC PRINT DATA=cars_raw (OBS=10);
    TITLE "First 10 Rows - Raw Data";
RUN;

PROC CONTENTS DATA=cars_raw;
    TITLE "Dataset Contents - Raw";
RUN;


/* STEP 2: EXPLORE THE DATA (PROC MEANS + FREQ) */

PROC MEANS DATA=cars_raw N NMISS MEAN STD MIN MAX MEDIAN;
    VAR year price mileage tax mpg engineSize;
    TITLE "Numerical Features - Before Cleaning";
RUN;

PROC MEANS DATA=cars_raw NMISS;
    VAR year price mileage tax mpg engineSize;
    TITLE "Missing Values per Column";
RUN;

PROC FREQ DATA=cars_raw;
    TABLES Make fuelType transmission;
    TITLE "Categorical Frequencies - Raw Data";
RUN;


/* STEP 3: CLEAN THE DATA */

DATA cars_clean;
    SET cars_raw;
    
    IF NMISS(year, price, mileage, tax, mpg, engineSize) > 0 THEN DELETE;
    
    IF STRIP(transmission) = "" OR STRIP(fuelType) = "" OR STRIP(Make) = "" THEN DELETE;
    IF STRIP(model) = "" THEN DELETE;
    
    Make = PROPCASE(STRIP(Make));
    
    
    IF Make = "Vw" THEN Make = "Volkswagen";
    
RUN;


PROC MEANS DATA=cars_clean N NMISS;
    VAR year price mileage tax mpg engineSize;
    TITLE "Missing Values - After Cleaning";
RUN;

PROC SQL;
    SELECT COUNT(*) AS rows_before, 
           (SELECT COUNT(*) FROM cars_clean) AS rows_after,
           COUNT(*) - (SELECT COUNT(*) FROM cars_clean) AS rows_dropped
    FROM cars_raw;
    TITLE "Row Count Before vs After Cleaning";
QUIT;


/*  STEP 4: FEATURE ENGINEERING */

DATA cars_featured;
    SET cars_clean;
    
    car_age = 2020 - year;
    LABEL car_age = "Car Age (years as of 2020)";
    
    price_per_mile = price / (mileage + 1);
    LABEL price_per_mile = "Price per Mile Driven (£)";
    
    IF engineSize > 0 THEN efficiency_score = mpg / engineSize;
    ELSE efficiency_score = mpg; 
    LABEL efficiency_score = "Fuel Efficiency Score (mpg per litre)";
    

    IF price > 14495 THEN high_price = 1;
    ELSE high_price = 0;
    LABEL high_price = "High Price Flag (1=Above Median, 0=Below Median)";
    
   
    IF Make = "Audi"        THEN Make_num = 1;
    ELSE IF Make = "Bmw"    THEN Make_num = 2;
    ELSE IF Make = "Ford"   THEN Make_num = 3;
    ELSE IF Make = "Volkswagen" THEN Make_num = 4;
    ELSE IF Make = "Toyota" THEN Make_num = 5;
    ELSE IF Make = "Skoda"  THEN Make_num = 6;
    ELSE IF Make = "Hyundai" THEN Make_num = 7;
    ELSE Make_num = 0;
    

    IF transmission = "Manual"    THEN trans_num = 1;
    ELSE IF transmission = "Automatic" THEN trans_num = 2;
    ELSE IF transmission = "Semi-Auto" THEN trans_num = 3;
    ELSE trans_num = 0;
    

    IF fuelType = "Petrol"   THEN fuel_num = 1;
    ELSE IF fuelType = "Diesel"  THEN fuel_num = 2;
    ELSE IF fuelType = "Hybrid"  THEN fuel_num = 3;
    ELSE IF fuelType = "Electric" THEN fuel_num = 4;
    ELSE fuel_num = 0;
    
RUN;


PROC MEANS DATA=cars_featured MEAN STD MIN MAX;
    VAR car_age price_per_mile efficiency_score;
    TITLE "Engineered Feature Statistics";
RUN;

PROC FREQ DATA=cars_featured;
    TABLES high_price Make_num trans_num fuel_num;
    TITLE "Encoded Variable Distributions";
RUN;


/* STEP 5: VISUALIZATIONS (PROC SGPLOT)  */


PROC SGPLOT DATA=cars_featured;
    HISTOGRAM price / FILLATTRS=(COLOR=CX2E86AB) TRANSPARENCY=0.1;
    REFLINE 14495 / AXIS=X LINEATTRS=(COLOR=RED THICKNESS=2 PATTERN=DASH)
        LABEL="Median: £14,495";
    TITLE "Distribution of Car Prices (£)";
    XAXIS LABEL="Price (£)";
    YAXIS LABEL="Frequency";
RUN;


PROC MEANS DATA=cars_featured NOPRINT;
    CLASS Make;
    VAR price;
    OUTPUT OUT=make_avg MEAN=avg_price;
RUN;

PROC SGPLOT DATA=make_avg (WHERE=(Make NE ""));
    HBAR Make / RESPONSE=avg_price FILLATTRS=(COLOR=CX2E86AB)
        DATALABEL DATALABELATTRS=(SIZE=9);
    TITLE "Average Car Price by Brand";
    XAXIS LABEL="Average Price (£)";
    YAXIS LABEL="Brand";
RUN;


PROC SGPLOT DATA=cars_featured;
    SCATTER X=mileage Y=price / TRANSPARENCY=0.8
        MARKERATTRS=(COLOR=CX2E86AB SIZE=4);
    LOESS X=mileage Y=price / LINEATTRS=(COLOR=CXC73E1D THICKNESS=2);
    TITLE "Car Price vs. Mileage";
    XAXIS LABEL="Mileage (miles)";
    YAXIS LABEL="Price (£)";
RUN;


PROC FREQ DATA=cars_featured;
    TABLES fuelType / OUT=fuel_freq NOPRINT;
RUN;
PROC GCHART DATA=fuel_freq;
    PIE fuelType / SUMVAR=COUNT
                   VALUE=INSIDE
                   PERCENT=INSIDE;
    TITLE "Fuel Type Distribution";
RUN;
QUIT;


PROC SGPLOT DATA=cars_featured (WHERE=(year >= 2012));
    VBOX price / CATEGORY=year FILLATTRS=(COLOR=CX44BBA4);
    TITLE "Car Price Distribution by Manufacture Year (2012-2020)";
    XAXIS LABEL="Year";
    YAXIS LABEL="Price (£)";
RUN;


PROC MEANS DATA=cars_featured NOPRINT;
    CLASS transmission;
    VAR price;
    OUTPUT OUT=trans_avg MEAN=avg_price;
RUN;
PROC SGPLOT DATA=trans_avg (WHERE=(transmission NE ""));
    VBAR transmission / RESPONSE=avg_price FILLATTRS=(COLOR=CXA23B72)
        DATALABEL DATALABELATTRS=(SIZE=9);
    TITLE "Average Price by Transmission Type";
    XAXIS LABEL="Transmission";
    YAXIS LABEL="Average Price (£)";
RUN;


PROC SGPLOT DATA=cars_featured;
    SCATTER X=engineSize Y=mpg / GROUP=high_price TRANSPARENCY=0.6
        MARKERATTRS=(SIZE=4);
    TITLE "MPG vs Engine Size by Price Category";
    XAXIS LABEL="Engine Size (Litres)";
    YAXIS LABEL="Miles Per Gallon" MAX=150;
RUN;


PROC SGPLOT DATA=cars_featured;
    VBAR Make / GROUP=high_price GROUPDISPLAY=CLUSTER;
    TITLE "High vs Low Price Cars by Brand";
    XAXIS LABEL="Brand";
    YAXIS LABEL="Number of Cars";
    KEYLEGEND / TITLE="Price Category (0=Low, 1=High)";
RUN;


/* STEP 6: SPLIT DATA INTO TRAIN / TEST */


DATA cars_train cars_test;
    CALL STREAMINIT(42);
    SET cars_featured;
    IF RAND("Uniform") <= 0.8 THEN OUTPUT cars_train;
    ELSE OUTPUT cars_test;
RUN;

PROC SQL;
    SELECT "Training Set" AS dataset, COUNT(*) AS n FROM cars_train
    UNION
    SELECT "Test Set", COUNT(*) FROM cars_test;
    TITLE "Train / Test Split";
QUIT;


/* STEP 7: BUILD AND EVALUATE LOGISTIC REGRESSION MODEL */


PROC LOGISTIC DATA=cars_train OUTMODEL=logit_model PLOTS(MAXPOINTS=NONE)=ROC;
    MODEL high_price(EVENT="1") =
        car_age
        mileage
        mpg
        engineSize
        tax
        price_per_mile
        efficiency_score
        Make_num
        fuel_num
        trans_num
        / LINK=LOGIT
          SELECTION=NONE
          LACKFIT;      
    OUTPUT OUT=train_scored PREDICTED=pred_prob;
    TITLE "Logistic Regression - Training Results";
RUN;


PROC LOGISTIC INMODEL=logit_model;
    SCORE DATA=cars_test OUT=test_scored FITSTAT;
    TITLE "Logistic Regression - Test Set Scoring";
RUN;


DATA test_results;
    SET test_scored;
    IF P_1 >= 0.5 THEN pred_class = 1;
    ELSE pred_class = 0;
RUN;


PROC FREQ DATA=test_results;
    TABLES high_price * pred_class / NOROW NOCOL NOPERCENT;
    TITLE "Confusion Matrix - Test Set";
RUN;


PROC SQL;
    SELECT 
        MEAN(high_price = pred_class) * 100 AS accuracy FORMAT=8.2
    FROM test_results;
    TITLE "Model Accuracy on Test Set (%)";
QUIT;


/* STEP 8: SCORE NEW RECORDS (Deployment Example) */


DATA new_cars;
    INFILE DATALINES DSD;
    INPUT year mileage mpg engineSize tax Make $ transmission $ fuelType $;

    car_age = 2020 - year;
    price_per_mile = . ; 
    IF engineSize > 0 THEN efficiency_score = mpg / engineSize;
    ELSE efficiency_score = mpg;

    IF Make = "Ford"    THEN Make_num = 3;
    IF Make = "Bmw"     THEN Make_num = 2;
    IF Make = "Audi"    THEN Make_num = 1;
    IF transmission = "Manual"    THEN trans_num = 1;
    IF transmission = "Automatic" THEN trans_num = 2;
    IF transmission = "Semi-Auto" THEN trans_num = 3;
    IF fuelType = "Petrol" THEN fuel_num = 1;
    IF fuelType = "Diesel" THEN fuel_num = 2;

    price_per_mile = 0.8;  
DATALINES;
2019,12000,45.6,1.0,145,Ford,Manual,Petrol
2018,25000,60.1,2.0,20,Bmw,Automatic,Diesel
2020,5000,38.2,3.0,165,Audi,Semi-Auto,Petrol
;


PROC LOGISTIC INMODEL=logit_model;
    SCORE DATA=new_cars OUT=new_predictions;
    TITLE "Predictions for New Car Listings";
RUN;

DATA new_predictions_labeled;
    SET new_predictions;
    IF P_1 >= 0.5 THEN Price_Category = "High Price";
    ELSE Price_Category = "Low Price";
RUN;

PROC PRINT DATA=new_predictions_labeled;
    VAR year mileage engineSize Make transmission P_1 Price_Category;
    TITLE "New Car Price Category Predictions";
RUN;


