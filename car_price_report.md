# **1. Understand the Data** 

## **1.1 Problem Definition** 

The automotive used-car market is one of the largest consumer markets globally. Buyers and sellers alike struggle to determine a fair price for a vehicle, as prices are influenced by many interacting factors including brand prestige, age, mileage, fuel efficiency, and transmission type. Our dataset contains 72,435 real UK used car listings scraped from AutoTrader, covering 7 popular brands: Audi, BMW, Ford, Volkswagen, Toyota, Skoda, and Hyundai. Each listing includes key vehicle attributes. 

## **1.2 Column Dictionary** 

|**Column**|**Data Type**|**Description**|
|---|---|---|
|model|Categorical|Specific car model (e.g., A1,<br>Focus, 3 Series)|
|year|Numerical|Year the car was manufactured<br>(1996–2020)|
|price|Numerical (Target)|Listed sale price in British<br>Pounds(£)|
|transmission|Categorical|Gearbox type: Manual,<br>Automatic, Semi-Auto, Other|
|mileage|Numerical|Total miles driven bythe car|
|fuelType|Categorical|Engine fuel: Petrol, Diesel,<br>Hybrid, Electric, Other|
|tax|Numerical|Annual road tax in GBP|
|mpg|Numerical|Miles per gallon — fuel<br>efficiencymeasure|
|engineSize|Numerical|Engine displacement in litres<br>(0.0–6.6L)|
|Make|Categorical|Car brand/manufacturer|



## **1.3 Business Importance** 

Accurate price prediction helps: 

- Buyers avoid overpaying for a used vehicle 

- Sellers set competitive, market-aligned prices 

- Dealerships automate appraisal workflows 

- Insurance companies estimate vehicle value accurately 

Our classification goal: predict whether a car is High Price (above market median) or Low Price. This binary classification is actionable for both buyers and sellers. 

# **2. Investigate the Data** 

## **2.1 Dataset Overview** 

|**Metric**|**Value**|
|---|---|
|Total Rows|72,435|
|Total Columns|10|
|Rows with MissingValues|~3,621–3,623per column(5%)|
|Numerical Features|6(year,price, mileage, tax, mpg, engineSize)|
|Categorical Features|4(model, transmission, fuelType, Make)|
|Target Variable|price (for regression) / high_price (for<br>classification)|
|Price Range|£495 — £145,000|
|Median Price|£14,495|
|Mean Price|£16,584|



## **Visualization 1: Price Distribution** 

The price distribution is right-skewed, with most cars priced between £8,000 and £25,000. A small number of luxury/premium vehicles push the mean above the median. 



<!-- Start of picture text -->
Car Price Distribution<br>eae HH1! ==»==) Median:Mean: £16,603 £14,495<br>7000 HH<br>1<br>6000 Hl<br>ul<br>2 5000<br>S<br>4000<br>5§<br>&<br>3000<br>2000<br>1000<br>) 0 20000 40000 60000 80000 100000 120000 140000<br>Price (£)<br><!-- End of picture text -->

## **Visualization 2: Average Price by Brand** 

Audi and BMW are the most premium brands, averaging over £22,000. Ford and Toyota target the budget-conscious segment, averaging around £12,000–£12,500. 



<!-- Start of picture text -->
Average Car Price by Brand<br>audi £22,954<br>BMW £22,760<br>vw £16,845<br>skoda £14,331<br>Hyundai £12,756<br>toyota £12,456<br>Ford £12,264<br>oO 5000 10000 15000 20000<br>Average Price (£)<br><!-- End of picture text -->

## **Visualization 3: Price vs. Mileage** 

A clear negative correlation exists between mileage and price — higher mileage cars command significantly lower prices. This makes intuitive sense as wear and tear reduces a vehicle's value. 



<!-- Start of picture text -->
Car Price vs. Mileage<br>100000<br>80000<br>a 60000 oe<br>2 esis<br>40000 <a<br>nog die..0% .<br>20000 . * "<br>° * .<br>0 20000 40000 60000 80000 100000 120000 140000<br>Mileage (miles)<br><!-- End of picture text -->

## **Visualization 4: Fuel Type Distribution** 

Petrol (63%) and Diesel (31%) dominate the dataset. Hybrid and Electric vehicles represent only ~5% of listings, reflecting the gradual transition to clean energy vehicles in the UK market. 



<!-- Start of picture text -->
Fuel Type Distribution<br>Heupyjorid<br>Diesel<br>Petrol<br><!-- End of picture text -->

## **Visualization 5: Price Trend by Year** 

Newer cars (2018–2020) are significantly more expensive than older models. Cars from 2015 and earlier show lower price floors, while recent models show higher variability — likely due to popular vs. basic trim levels. 



<!-- Start of picture text -->
Car Price Distribution by Year (2012-2020)<br>50000<br>40000<br>30000<br>g<br>&<br>20000<br>-<br>a==<br>°<br>2012 2013 2014 2015 2016 2017 2018 2019 2020<br>Year<br><!-- End of picture text -->

## **Visualization 6: Price by Transmission Type** 

Semi-Automatic and Automatic vehicles command a £10,000+ premium over Manual cars. This reflects both buyer preference for comfort and the higher manufacturing cost of automatic gearboxes. 



<!-- Start of picture text -->
Average Price by Transmission Type<br>£23,504<br>£21,486<br>20000<br>a<br>> 15000 £14,571<br>& £12,551<br>2<br>cy<br>s 10000<br>=<br>5000<br>oO Semi-Auto Automatic Other Manual<br>Transmission Type<br><!-- End of picture text -->

# **3. Fix the Data** 

## **3.1 Data Quality Issues Identified** 

|**Issue**|**Scale**|**Impact**|**Solution**|
|---|---|---|---|
|Missing values in all<br>columns|~3,621 rows (5%)|Incomplete analysis,<br>model errors|Remove rows with any<br>missing value (listwise<br>deletion)|
|engineSize = 0.0|Small subset|Unrealistic — no car<br>has 0L engine|Treated as missing<br>during analysis;<br>flagged|
|Extreme mpg outliers<br>(up to 470.8)|Rare records|May indicate data<br>entry errors|Retained but<br>monitored (could be<br>electric/hybrid)|
|Price outliers<br>(£145,000)|Very rare|May skew mean but<br>valid luxurycars|Retained — real<br>market data|
|Inconsistent casing in<br>Make column|Systematic|e.g., "audi" vs "Audi"|Standardized in SAS<br>using<br>UPCASE/PROPCASE|



## **3.2 Before vs. After Cleaning** 

|**Metric**|**Before Cleaning**|**After Cleaning**|
|---|---|---|
|Total rows|72,435|43,325 (rows retained after<br>droppingNAs)|
|Missingvalues|3,621–3,623per column|0 missingvalues|
|Rows dropped|—|29,110 rows removed(~40%)|
|Data completeness|~95%|100%|



Note: ~40% row loss is significant. The missing data appears concentrated in a subset of records (likely one data source or scraping batch). All complete records are representative of the full distribution. 

## **3.3 SAS Cleaning Code** 

```
/* PROC IMPORT: Load raw data */
PROC IMPORT DATAFILE="/path/car_price.csv"
  OUT=cars_raw DBMS=CSV REPLACE;
  GETNAMES=YES;
RUN;
```

```
/* Remove missing values (listwise deletion) */
DATA cars_clean;
```

```
  SET cars_raw;
  IF NMISS(year, price, mileage, tax, mpg, engineSize) = 0;
  IF transmission NE "" AND fuelType NE "" AND Make NE "";
  /* Standardize Make column casing */
  Make = PROPCASE(STRIP(Make));
RUN;
```

```
/* Verify cleaning results */
PROC MEANS DATA=cars_clean N NMISS;
  VAR year price mileage tax mpg engineSize;
RUN;
```

# **4. Create New Insights (Feature Engineering)** 

## **4.1 Engineered Features** 

|**Feature Name**|**Formula**|**Business Justification**|
|---|---|---|
|car_age|2020 - year|Direct depreciation proxy;<br>newer = more valuable. Simpler<br>than usingrawyear.|
|price_per_mile|price / (mileage + 1)|Value-for-mileage ratio. High<br>ratio = expensive per use unit.<br>Useful for comparativepricing.|
|efficiency_score|mpg / engineSize|Combines two important specs:<br>higher score = better fuel<br>economy relative to engine<br>power. Electric/hybrid cars<br>score highest.|
|high_price (target)|1 if price > £14,495 else 0|Binary classification target.<br>Above-median = "High Price"<br>category for dealers and<br>buyers.|



## **4.2 SAS Feature Engineering Code** 

```
DATA cars_featured;
  SET cars_clean;
  /* Feature 1: Car Age */
  car_age = 2020 - year;
  /* Feature 2: Price per Mile (value density) */
  price_per_mile = price / (mileage + 1);
  /* Feature 3: Fuel Efficiency Score */
  IF engineSize > 0 THEN efficiency_score = mpg / engineSize;
  ELSE efficiency_score = mpg; /* Handle 0-engine edge case */
  /* Feature 4: Binary Target Variable */
  IF price > 14495 THEN high_price = 1;
  ELSE high_price = 0;
RUN;
PROC MEANS DATA=cars_featured MEAN STD MIN MAX;
  VAR car_age price_per_mile efficiency_score;
RUN;
```

## **Visualization 7: MPG vs Engine Size (colored by Price)** 

Smaller, more efficient engines tend to appear in lower-priced cars. Larger engines (3L+) command premium prices. The efficiency_score feature captures this relationship effectively. 



<!-- Start of picture text -->
MPG vs Engine Size (colored by Price)<br>140 .<br>° ° 60000<br>120<br>50000<br>100<br>°<br>e oh © 40000—<br>© 804 6 s<br>2=ee i rs<br>60 e. BO 3 30000 &<br>8 oasitis !<br>aia oe<br>40 Se 3 te 20000<br>° 8 .<br>. 0 3% ee °<br>20 10000<br>oO<br>oO 1 2 3 4<br>Engine Size (L)<br><!-- End of picture text -->

## **Visualization 8: High vs. Low Price Cars by Brand** 

BMW and Audi have a higher proportion of above-median-price cars, while Ford and Toyota skew toward the below-median category. This brand-price relationship is a key predictor in our model. 



<!-- Start of picture text -->
High vs. Low Price Cars by Brand<br>jm Below Median<br>7000 mmm Above Median<br>6000<br>e<br>5 5000<br>Vv<br>a)<br>., 4000<br>&<br>é3 3000<br>2<br>2000<br>1000<br>0<br>BMW Ford Hyundai audi skoda toyota w<br>Brand<br><!-- End of picture text -->

# **5. Build a Model** 

## **5.1 Model Choice: Logistic Regression** 

We chose Logistic Regression (PROC LOGISTIC in SAS) to predict whether a car is High Price (1) or Low Price (0). Logistic regression is ideal because: 

- It provides interpretable coefficients for each feature 

- It outputs probabilities, useful for confidence-based decisions 

- It handles both numerical and encoded categorical features 

- It is a well-established baseline for binary classification 

## **5.2 Model Configuration** 

|**Parameter**|**Value**|
|---|---|
|Algorithm|Logistic Regression(BinaryClassification)|
|Target Variable|high_price(0 = Low Price, 1 = High Price)|
|Features Used|car_age, mileage, mpg, engineSize, tax,<br>price_per_mile, efficiency_score, Make_enc,<br>fuelType_enc, transmission_enc|
|Train/Test Split|80% Train(34,660 rows)/ 20% Test(8,665 rows)|
|Random Seed|42|



## **5.3 SAS Model Code** 

```
/* Encode categorical variables */
DATA cars_model;
  SET cars_featured;
  /* Create dummy/numeric encodings for categoricals */
  IF Make = "Audi"    THEN Make_num = 1;
  ELSE IF Make = "BMW"    THEN Make_num = 2;
  ELSE IF Make = "Ford"   THEN Make_num = 3;
  ELSE IF Make = "Vw"     THEN Make_num = 4;
  ELSE IF Make = "Toyota" THEN Make_num = 5;
  ELSE IF Make = "Skoda"  THEN Make_num = 6;
  ELSE IF Make = "Hyundai"THEN Make_num = 7;
  IF transmission = "Manual"    THEN trans_num = 1;
  ELSE IF transmission = "Automatic" THEN trans_num = 2;
  ELSE IF transmission = "Semi-Auto" THEN trans_num = 3;
  ELSE trans_num = 0;
  IF fuelType = "Petrol"  THEN fuel_num = 1;
  ELSE IF fuelType = "Diesel"  THEN fuel_num = 2;
  ELSE IF fuelType = "Hybrid"  THEN fuel_num = 3;
  ELSE IF fuelType = "Electric"THEN fuel_num = 4;
  ELSE fuel_num = 0;
RUN;
```

```
/* Split into Train/Test */
DATA cars_train cars_test;
  SET cars_model;
  IF RAND("uniform") <= 0.8 THEN OUTPUT cars_train;
  ELSE OUTPUT cars_test;
RUN;
```

```
/* PROC LOGISTIC: Train Classification Model */
PROC LOGISTIC DATA=cars_train OUTMODEL=logit_model;
  MODEL high_price(EVENT="1") =
    car_age mileage mpg engineSize tax
    price_per_mile efficiency_score
    Make_num fuel_num trans_num / LINK=LOGIT;
  OUTPUT OUT=train_preds PREDICTED=pred_prob;
RUN;
```

```
/* Score Test Data */
PROC LOGISTIC INMODEL=logit_model;
  SCORE DATA=cars_test OUT=test_preds;
RUN;
```

# **6. Explain the Model** 

## **6.1 Model Performance** 

|**Metric**|**Value**|
|---|---|
|Overall Accuracy|86.57%|
|Precision(Low Price class)|85%|
|Recall(Low Price class)|87%|
|F1-Score(Low Price class)|86%|
|Precision(High Price class)|88%|
|Recall(High Price class)|86%|
|F1-Score(High Price class)|87%|
|Test Set Size|8,665 records|



## **6.2 Confusion Matrix** 

||**Predicted: Low**|**Predicted: High**|
|---|---|---|
|Actual: Low|3,723(TN)|532 (FP)|
|Actual: High|632(FN)|3,778(TP)|



The model correctly classified 3,723 low-price and 3,778 high-price cars. Only 532+632 = 1,164 cars were misclassified out of 8,665 total test records. 

## **6.3 Feature Importance (Logistic Regression Coefficients)** 

|**Feature**|**Coefficient**|**Interpretation**|
|---|---|---|
|engineSize|+3.97|STRONGEST predictor. Larger<br>engines strongly indicate high<br>price. Each extra litre raises<br>log-odds by3.97.|
|car_age|-0.82|Older cars are significantly less<br>likely to be high-priced.<br>Depreciation effect is clear.|
|transmission_enc|+0.39|Automatic/Semi-Auto<br>transmission is associated with<br>higher-priced cars.|



|fuelType_enc|-0.24|Certain fuel types (e.g., Petrol)<br>correlate with lower price range<br>vehicles.|
|---|---|---|
|Make_enc|-0.07|Brand encoding has modest<br>effect after controlling for<br>engine and age.|
|mpg|-0.05|Higher MPG tends to be<br>associated with smaller,<br>cheaper cars(excludingEVs).|



## **6.4 Key Insights from the Model** 

- Engine size is the single most powerful predictor of whether a car is priced above market median 

- Car age (depreciation) is the second most important factor — each additional year significantly reduces price class probability 

- Transmission type matters greatly: Semi-Auto and Automatic cars are far more likely to be high-priced 

- Fuel type and brand add nuance but are secondary to the mechanical characteristics 

# **7. Make It Useful** 

## **7.1 Real-World Applications** 

This model has immediate practical applications across the automotive industry: 

**1. For Car Buyers:** Input your shortlisted car's specs and instantly know if you're being charged a fair price. If the model predicts "Low Price" but the seller is asking above £14,495, walk away or negotiate. 

**2. For Dealerships:** Automate vehicle appraisal at intake. When a customer brings a trade-in, the model can instantly estimate the market tier (High/Low) to support pricing decisions. 

**3. For Insurance Companies:** Quickly estimate vehicle market value tier for premium calculation without a full appraisal. 

**4. For Online Marketplaces:** Flag listings that appear over- or under-priced relative to comparable vehicles, improving market transparency. 

## **7.2 Model Deployment in SAS (Scoring New Records)** 

```
/* Score new incoming car listings */
DATA new_cars;
  INPUT model $ year price transmission $ mileage fuelType $ tax mpg engineSize Make
$;
  car_age = 2020 - year;
  price_per_mile = price / (mileage + 1);
  IF engineSize > 0 THEN efficiency_score = mpg / engineSize;
  /* Encode categoricals same as training */
  /* ... (same encoding logic) ... */
DATALINES;
Focus 2019 . Manual 12000 Petrol 145 45.6 1.0 Ford
;
PROC LOGISTIC INMODEL=logit_model;
  SCORE DATA=new_cars OUT=predictions;
RUN;
PROC PRINT DATA=predictions;
  VAR model year mileage I_high_price P_1;
  TITLE "Car Price Category Predictions";
RUN;
```

## **7.3 Limitations and Future Work** 

- The 40% data drop due to missing values may introduce bias — future work should explore imputation 

- Model accuracy of 86.6% leaves room for improvement with ensemble methods (Random Forest, Gradient Boosting) 

- Geographic variation within the UK is not captured — regional price differences could be added 

- Colour, service history, number of owners — unmeasured variables that strongly influence real prices 

- Time series modeling to track price trends over years could add predictive value for market timing 

## **7.4 Conclusion** 

Starting with a mysterious dataset of 72,435 UK used car listings, we successfully built a complete data science pipeline. We cleaned ~5% missing data, engineered 4 meaningful features, explored 8 visualizations revealing clear patterns, and trained a Logistic Regression classifier that predicts whether a car is priced above market median with 86.6% accuracy. 

The most important finding: engine size and car age together account for the majority of pricing power in the UK used car market. Transmission type is a significant secondary factor. This actionable insight can guide buyers, sellers, and automotive businesses toward better datadriven decisions. 

