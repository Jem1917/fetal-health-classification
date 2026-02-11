# fetal-health-classification
Clinical predictive model for fetal health classification from cardiotocogram data using logistic regression in SAS. Supports early intervention and maternal-fetal health monitoring.

## 📋 Project Overview

This project develops **predictive models for fetal health classification** using Cardiotocogram (CTG) data to enable early intervention and reduce maternal-fetal mortality. The analysis employs binary and multinomial logistic regression in SAS to classify fetal health status into Normal, Suspect, and Pathological categories.

**Clinical Impact:** 295,000 maternal deaths occur annually (WHO), with many preventable through early detection. This model supports UN Sustainable Development Goal 3 by enabling timely clinical intervention.

---

## 🎯 Key Objectives

1. **Predict fetal health status** from CTG measurements
2. **Identify significant clinical predictors** of fetal distress
3. **Develop interpretable models** for clinical decision support
4. **Evaluate model performance** using ROC analysis and classification metrics

---

## 📊 Dataset

- **Source:** [Fetal Health Classification Dataset](https://www.kaggle.com/datasets/andrewmvd/fetal-health-classification) (Kaggle)
- **Size:** 2,126 CTG examinations
- **Features:** 21 continuous variables from CTG recordings
  - Baseline fetal heart rate (FHR)
  - Accelerations and decelerations
  - Fetal movement
  - Uterine contractions
  - Heart rate variability metrics
  - Histogram-based features
- **Outcome:** Fetal health status (1=Normal, 2=Suspect, 3=Pathological)
  - Expert-classified by 3 obstetricians

### Class Distribution
- **Normal:** 1,655 (77.85%)
- **Suspect:** 295 (13.88%)
- **Pathological:** 176 (8.28%)

> ⚠️ **Note:** Dataset exhibits class imbalance, addressed through appropriate modeling techniques.

---

## 🛠️ Methodology

### 1. Data Preparation
- Data import and validation (PROC IMPORT)
- Missing data assessment (0% missing)
- Feature engineering (categorical variables, binary outcome)
- Data quality checks

### 2. Exploratory Data Analysis
- **Descriptive statistics** by health status (PROC MEANS)
- **Distribution analysis** (PROC UNIVARIATE)
- **Correlation analysis** (PROC CORR)
- **Frequency distributions** (PROC FREQ)
- **Visualizations** (PROC SGPLOT)

### 3. Statistical Modeling

#### Binary Logistic Regression
- **Outcome:** Abnormal (Suspect or Pathological) vs Normal
- **Method:** Maximum likelihood estimation
- **Variable selection:** Stepwise selection with α=0.05

#### Multinomial Logistic Regression
- **Outcome:** 3-class classification (Normal, Suspect, Pathological)
- **Method:** Cumulative logit model
- **Assumption testing:** Proportional odds assumption

### 4. Model Evaluation
- ROC curve analysis
- Confusion matrix
- Performance metrics: Accuracy, Sensitivity, Specificity, AUC
- Model diagnostics: Hosmer-Lemeshow test, influence statistics

---

## 📈 Key Results

### Binary Logistic Regression Performance

| Metric | Value |
|--------|-------|
| **AUC (ROC)** | 0.881 |
| **Accuracy** | 84.24% |
| **Sensitivity** | 54.35% |
| **Specificity** | 92.75% |

### Significant Predictors (p < 0.05)

| Variable | Odds Ratio | 95% CI | p-value | Clinical Interpretation |
|----------|-----------|---------|---------|------------------------|
| **Baseline FHR** | 1.060 | (1.046, 1.075) | <0.0001 | 6% increased odds per 1 bpm increase |
| **Accelerations** | <0.001 | (<0.001, <0.001) | <0.0001 | Protective factor (more = lower risk) |
| **Severe Decelerations** | >999.999 | (>999.999, >999.999) | 0.0037 | Strong risk factor for abnormal status |
| **Uterine Contractions** | <0.001 | (<0.001, <0.001) | <0.0001 | Complex relationship with outcome |
| **Fetal Movement** | 575.238 | (39.114, >999.999) | <0.0001 | Associated with increased odds |

### Model Fit Statistics
- **AIC:** 1,473.492 (lower is better)
- **Likelihood Ratio Test:** χ² = 787.19, p < 0.0001
- **Hosmer-Lemeshow Test:** χ² = 13.02, p = 0.1112 (good fit)
- **Cox & Snell R²:** 0.3095
- **Max-rescaled R²:** 0.4741

### Stepwise Selection Results (6 variables selected)
- **Final AUC:** 0.931
- **Variables:** accelerations, prolonged decelerations, uterine contractions, baseline FHR, severe decelerations, light decelerations

---

## 🔍 Key Findings

### Clinical Insights

1. **Baseline FHR Elevation:** Suspect cases showed significantly higher baseline FHR (141.68 bpm) compared to Normal (131.98 bpm) and Pathological (131.69 bpm), suggesting tachycardia as an early warning sign.

2. **Accelerations as Protective Factor:** Strong negative association (r = -0.39) indicates fetal well-being when accelerations are present.

3. **Decelerations as Risk Indicators:** Severe and prolonged decelerations dramatically increase odds of abnormal status, consistent with clinical knowledge.

### Model Performance Analysis

**Strengths:**
- Excellent discrimination (AUC = 0.881)
- High specificity (92.75%) minimizes false alarms
- Good overall accuracy (84.24%)
- Interpretable odds ratios for clinical use

**Limitations:**
- **Low sensitivity (54.35%)** - misses ~45% of abnormal cases
  - Critical concern for clinical application (false negatives = missed interventions)
  - Likely due to class imbalance (only 22% abnormal cases)
- **Class imbalance** affects model's ability to detect minority classes
- **Threshold optimization** needed to balance sensitivity-specificity tradeoff

---

## 💻 Technologies Used

- **SAS 9.4** (SAS OnDemand for Academics)
- **PROC IMPORT** - Data ingestion
- **PROC MEANS, PROC FREQ, PROC UNIVARIATE** - Descriptive statistics
- **PROC CORR** - Correlation analysis
- **PROC LOGISTIC** - Binary and multinomial logistic regression
- **PROC SGPLOT** - Data visualization
- **DATA step programming** - Data manipulation

---

## 📁 Repository Structure

```
fetal-health-classification/
│
├── README.md                          # Project overview (this file)
├── data/
│   ├── fetal_health.csv              # Raw dataset
│   └── data_dictionary.md            # Variable descriptions
│
├── code/
│   ├── fetal_health_proj.sas 
│
├── output/
│   ├── data_import_exploration.pdf
│   ├── data_cleaning.pdf
│   ├── descriptive_statistics.pdf
│   ├── binary_logistic_regression.pdf
│   ├── roc_curve_binary.pdf
│   ├── multinomial_logistic.pdf
│   ├── model_evaluation.pdf
│   ├── stepwise_selection.pdf
│   ├── correlation_analysis.pdf
│   ├── visualizations/      
│                ├── 
│                ├── baseline_fhr_boxplot.png
│                ├── health_status_distribution.png
│                ├── health_status_distribution1.png
│                ├── health_status_distribution2.png
│                ├── health_status_distribution3.png
│                ├── health_status_distribution4.png
│                └── roc_curve_binary.png
│
└── LICENSE                           # MIT License
```

---

## 🚀 How to Run

### Prerequisites
- SAS 9.4 or SAS OnDemand for Academics (free)
- Fetal Health Classification dataset from Kaggle

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/fetal-health-classification.git
   cd fetal-health-classification
   ```

2. **Download the dataset**
   - Visit [Kaggle Dataset](https://www.kaggle.com/datasets/andrewmvd/fetal-health-classification)

3. **Run SAS programs in order**
   ```sas
   /* In SAS Studio or SAS OnDemand */
   %include 'code/01_data_import_cleaning.sas';
   %include 'code/02_exploratory_analysis.sas';
   %include 'code/03_binary_logistic.sas';
   %include 'code/04_multinomial_logistic.sas';
   %include 'code/05_model_diagnostics.sas';
   %include 'code/06_stepwise_selection.sas';
   ```

4. **Review outputs**
   - Check `output/` folder for results

---

## 🎓 Educational Value

This project demonstrates:

- **Clinical biostatistics** application in maternal-fetal health
- **Binary and multinomial logistic regression** implementation in SAS
- **Model evaluation** using ROC analysis, confusion matrices, and fit statistics
- **Variable selection** techniques (stepwise)
- **Interpretation** of odds ratios in clinical context
- **Model diagnostics** (Hosmer-Lemeshow, influence analysis)
- **Handling imbalanced data** challenges
- **Statistical communication** for both technical and clinical audiences

---

## 📚 Future Improvements

1. **Address Class Imbalance**
   - SMOTE (Synthetic Minority Over-sampling)
   - Class weights adjustment
   - Threshold optimization for sensitivity

2. **Feature Engineering**
   - Interaction terms (e.g., baseline_value × accelerations)
   - Polynomial terms for non-linear relationships
   - Domain-driven feature creation

3. **Model Enhancement**
   - Cross-validation for robust performance estimates
   - Ensemble methods (Random Forest, XGBoost)
   - External validation on independent dataset

4. **Clinical Deployment**
   - Cost-sensitive learning (weight false negatives higher)
   - Decision curve analysis for clinical utility
   - Integration with electronic health records (EHR)

---

## 📖 References

1. Ayres de Campos et al. (2000). SisPorto 2.0: A Program for Automated Analysis of Cardiotocograms. *Journal of Maternal-Fetal Medicine*, 9(5), 311-318.

2. World Health Organization. (2019). Maternal Mortality. Retrieved from https://www.who.int/news-room/fact-sheets/detail/maternal-mortality

3. Hosmer, D. W., Lemeshow, S., & Sturdivant, R. X. (2013). *Applied Logistic Regression* (3rd ed.). Wiley.

4. Dataset: [Fetal Health Classification](https://www.kaggle.com/datasets/andrewmvd/fetal-health-classification) on Kaggle

---

## 👤 Author

**Praisie Jemimah**
- Email: akkepogupraisie@gmail.com
- GitHub: Jem1917(https://github.com/Jem1917)
- LinkedIn: Praisie Jemimah

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙏 Acknowledgments

- Dataset provided by Ayres de Campos et al. via Kaggle
- SAS OnDemand for Academics for computational resources

---

## 📞 Contact

For questions, collaborations, or opportunities, please reach out via:
- Email: akkepogupraisie@gmailcom
- LinkedIn: Praisie Jemimah

---

**⭐ If you find this project useful, please consider giving it a star!**
