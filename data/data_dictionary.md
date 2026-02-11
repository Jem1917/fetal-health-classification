# Data Dictionary - Fetal Health Classification Dataset

## Overview
This dataset contains 2,126 Cardiotocogram (CTG) examinations, each classified by expert obstetricians into one of three fetal health categories.

---

## Target Variable

| Variable | Type | Values | Description |
|----------|------|--------|-------------|
| `fetal_health` | Categorical | 1, 2, 3 | **1** = Normal<br>**2** = Suspect<br>**3** = Pathological |

---

## Predictor Variables (21 features)

### Heart Rate Features

| Variable | Type | Unit | Range | Description |
|----------|------|------|-------|-------------|
| `baseline_value` | Continuous | bpm | 106-160 | Baseline fetal heart rate (FHR) |
| `accelerations` | Continuous | count/sec | 0-0.019 | Number of accelerations per second<br>*Accelerations = temporary increases in FHR ≥15 bpm lasting ≥15 sec* |
| `fetal_movement` | Continuous | count/sec | 0-0.481 | Fetal movements per second |

### Deceleration Features

| Variable | Type | Unit | Range | Description |
|----------|------|------|-------|-------------|
| `light_decelerations` | Continuous | count/sec | 0-0.015 | Number of light decelerations per second<br>*Light = FHR drop <15 bpm or duration <15 sec* |
| `severe_decelerations` | Continuous | count/sec | 0-0.001 | Number of severe decelerations per second<br>*Severe = abrupt FHR drop ≥15 bpm* |
| `prolongued_decelerations` | Continuous | count/sec | 0-0.005 | Number of prolonged decelerations per second<br>*Prolonged = FHR drop lasting >2 min but <10 min* |

### Uterine Activity

| Variable | Type | Unit | Range | Description |
|----------|------|------|-------|-------------|
| `uterine_contractions` | Continuous | count/sec | 0-0.015 | Number of uterine contractions per second |

### Heart Rate Variability Features

| Variable | Type | Unit | Range | Description |
|----------|------|------|-------|-------------|
| `abnormal_short_term_variability` | Continuous | % | 12-87 | Percentage of time with abnormal short-term variability<br>*Short-term = beat-to-beat variations* |
| `mean_value_of_short_term_variability` | Continuous | ms | 0.2-7.0 | Mean value of short-term variability |
| `percentage_of_time_with_abnormal_long_term_variability` | Continuous | % | 0-91 | Percentage of time with abnormal long-term variability<br>*Long-term = variations over 1 min* |
| `mean_value_of_long_term_variability` | Continuous | ms | 0-50.7 | Mean value of long-term variability |

### Histogram Features
*Histogram features describe the distribution of FHR values during the examination*

| Variable | Type | Unit | Range | Description |
|----------|------|------|-------|-------------|
| `histogram_width` | Continuous | bpm | 3-180 | Width of FHR histogram (max - min) |
| `histogram_min` | Continuous | bpm | 50-159 | Minimum value in FHR histogram |
| `histogram_max` | Continuous | bpm | 122-238 | Maximum value in FHR histogram |
| `histogram_number_of_peaks` | Continuous | count | 0-18 | Number of peaks in the histogram |
| `histogram_number_of_zeroes` | Continuous | count | 0-10 | Number of histogram bins with zero values |
| `histogram_mode` | Continuous | bpm | 60-187 | Mode (most frequent value) of FHR histogram |
| `histogram_mean` | Continuous | bpm | 73-182 | Mean of FHR histogram |
| `histogram_median` | Continuous | bpm | 77-186 | Median of FHR histogram |
| `histogram_variance` | Continuous | bpm² | 0-269 | Variance of FHR histogram |
| `histogram_tendency` | Categorical | -1, 0, 1 | **-1** = Left asymmetric<br>**0** = Symmetric<br>**1** = Right asymmetric |

---

## Derived Variables (Created in Analysis)

| Variable | Type | Values | Description |
|----------|------|--------|-------------|
| `health_status` | Character | "Normal", "Suspect", "Pathological" | Labeled version of fetal_health |
| `abnormal` | Binary | 0, 1 | **0** = Normal<br>**1** = Abnormal (Suspect or Pathological) |

---

## Clinical Context

### Cardiotocography (CTG)
CTG simultaneously records:
1. **Fetal heart rate** (via ultrasound transducer)
2. **Uterine contractions** (via pressure transducer)

### Normal CTG Patterns (Reassuring)
- Baseline FHR: 110-160 bpm
- Moderate variability: 5-25 bpm
- 2+ accelerations per 20 minutes
- No decelerations

### Abnormal CTG Patterns (Non-reassuring)
- Baseline FHR <110 or >160 bpm (bradycardia/tachycardia)
- Minimal variability (<5 bpm)
- Absent accelerations
- Variable or late decelerations
- Prolonged decelerations

### Interpretation Categories
- **Normal (Category I):** No intervention required
- **Suspect (Category II):** Requires close monitoring, may need intervention
- **Pathological (Category III):** Immediate intervention likely needed

---

## Data Quality Notes

### Missing Values
- **0 missing values** across all 2,126 observations
- Complete data for all 21 predictors and outcome

### Data Range Checks
All values fall within physiologically plausible ranges:
- Baseline FHR: 106-160 bpm ✓ (normal range 110-160)
- All continuous variables non-negative ✓
- No obvious data entry errors identified

### Class Distribution
- **Imbalanced dataset:**
  - Normal: 77.85% (n=1,655)
  - Suspect: 13.88% (n=295)
  - Pathological: 8.28% (n=176)

### Correlations
Key correlations with abnormal outcome:
- `accelerations`: r = -0.39 (protective)
- `baseline_value`: r = +0.25 (risk factor)
- `severe_decelerations`: r = +0.09 (risk factor)

---

## Usage Notes

### For Statistical Analysis
- All predictors are numeric (continuous or discrete counts)
- Outcome can be used as binary (abnormal vs normal) or 3-class
- Consider class imbalance when building models
- Some variables have extreme skewness (e.g., decelerations)

### For Clinical Interpretation
- Variables are per-second rates (divide by exam duration if needed)
- Histogram features summarize FHR distribution patterns
- Multiple features capture different aspects of fetal well-being

### Data Source
- **Original source:** SisPorto 2.0 CTG analysis software
- **Expert classification:** 3 obstetricians reviewed each exam
- **Publication:** Ayres de Campos et al. (2000)
- **Public access:** Kaggle (CC0: Public Domain)

---

## References

1. Ayres-de-Campos, D., Spong, C. Y., & Chandraharan, E. (2015). FIGO consensus guidelines on intrapartum fetal monitoring: Cardiotocography. *International Journal of Gynecology & Obstetrics*, 131(1), 13-24.

2. Macones, G. A., et al. (2008). The 2008 National Institute of Child Health and Human Development workshop report on electronic fetal monitoring. *Obstetrics & Gynecology*, 112(3), 661-666.

---

## Version History
- **v1.0** (2024): Initial dataset release on Kaggle
- **Updated:** February 2026 (This documentation)
