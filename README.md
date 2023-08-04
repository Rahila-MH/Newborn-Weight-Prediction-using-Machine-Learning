# Newborn-Weight-Prediction-using-Machine-Learning

In this machine learning project, I use Ridge Regression and other algorithms to predict newborn weight based on essential characteristics. The goal is to build a regression model that accurately explains newborn weight and generates predictions for a test dataset. Evaluation is performed using the Mean Absolute Percentage Error (MAPE) metric.

My first steps involve thorough Data Preprocessing and Exploratory Data Analysis (EDA) to ensure the dataset's quality and glean valuable insights. 
During the Data Preprocessing phase, i cleaned the data, handled missing values, and performed feature engineering. This step is critical for ensuring the dataset is consistent, reliable, and ready for modeling. By addressing missing information and engineering relevant features, we enhance the dataset's suitability for machine learning algorithms.
After preprocessing data, i moved into Exploratory Data Analysis (EDA). EDA allows us to visually and statistically analyze the relationships between different variables and their impact on newborn weight. Through data visualization and summary statistics, we uncover patterns, correlations, and potential outliers, gaining a deeper understanding of the data's characteristics.

Once the data is prepared and insights are gained from EDA, i proceed with building the regression model. In this project, i applied various machine learning algorithms, including Ridge Regression, linear regression and etc. Ridge Regression stands out for its ability to handle multicollinearity in the data, which can significantly impact model performance.

To evaluate the predictive performance of models, i used the Mean Absolute Percentage Error (MAPE) metric. MAPE calculates the percentage difference between actual and predicted newborn weights, providing a meaningful assessment of the model's accuracy. 

## Description of dataset
The dataset includes 2398116 observations in the training sample and 599561 in the test sample and the following columns:

The dataset includes 2398116 observations in the training sample and 599561 in the test sample and the following columns:

mother_body_mass_index – Body Mass Index of the mother

mother_marital_status – is mother married? (1 = Yes, 2 = No)

mother_delivery_weight – mother’s weight at delivery in pounds

mother_race – race of the mother (1 = White (alone); 2 = Black (alone); 3 = AIAN (alone); 4 Asian (alone); 5 = NHOPI (alone); 6 = More than one race)

mother_height – height of the mother in inches

mother_weight_gain – mother’s weight gain during the pregnancy (in pounds)

father_age – age of the father

father_education – education of the father (1 = 8th grade or less; 2 = 9-12th grade, no diploma; 3 = High school graduate or GED completed; 4 = Some college credit but no 
degree; 5 = Associate degree; 6 = Bachelor’s degree; 7 = Master’s degree; 8 = Doctorate or Professional degree; 9 = unknown)

cigarettes_before_pregnancy – number of cigarettes smoked daily by the mother before pregnancy (00-97 = number of cigarettes daily, 98 = 98 or more cigarettes daily)

prenatal_care_month – pregnancy month in which prenatal care began (99 = no prenatal care)

number_prenatal_visits – number of prenatal visits

previous_cesarean – was there any previous cesarean delivery before (N = No; Y = Yes; U = Other)

newborn_gender – gender of the newborn (F = female; M = male)

newborn_weight – weight of the newborn in grams (outcome variable, only in the training sample)
