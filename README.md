# Thesis project: Utilizing the MNLFA model to test for DIPF with a continuous background variable

This repository contains the code used for my Master's Thesis project titled '"Utilizing the MNLFA model to test for DIPF with a continuous background variable". In this project, method to test for differential item-pair functioning (DIPF) using a continuous background variable was developed, by clustering the estimates from a Moderated Nonlinear Factor Analysis (MNLFA) model. This method, the DIPF-MNLFA method, allows for assessing measurement invariance across a continuous background variable, while taking the non-identifiability of the item difficulties into account. 

The repository is split up into two folders, one folder contains the R scripts used in a simulation study, the other contains the scripts used in a real data example using PISA data. Both will now briefly be explained and discussed.

## Simulation study
In the simulation study, feasibility of the DIPF-MNLFA method was assessed through evaluating the power and bias method with a continuous background variable. Additionally differences (in power, bias, and computational time) between using a continous background variable versus dichotomizing the variable were assessed as well. Parameters that differed across conditions were: sample size, strength of DIF, and number of DIF items.

The folder is structured as follows:

| Files/Folders                 | Description   |
| -----------------             | ------------- |
|1 simulate data.R              |R-script for simulating the data|
|2 MNLFA_cont.R                 |R-script for fitting the MNLFA to each data set using a continuous background variable |
|3 MNLFA_dich.R                 |R-script for fitting the MNLFA to each data set using a dichotomized background variable |
|/RDS_objects                   |Folder with RDS objects created by running the R scripts|

Note that the R scripts for fitting the models (2 and 3) reference a folder "MNLFA models" within the "RDS objects" folder. This folder can be created to store the list of MNLFA models. However, the files were to large to be stored on GitHub, but they can be produced by running the code (this might take some time).

## PISA analysis
Data from the Programme for International Student Assessment (PISA) was used to provide a real data example. The data can be obtained [here](https://www.oecd.org/pisa/data/2015database/). A pre-processed data set was provided by the project's supervisor, Remco Feskens from [Cito](https://www.cito.nl/). The goal of the analysis was to explore whether or not the DIPF-MNLFA method could identify item clusters based on item content. Additionally, the focus was again on the effects of dichotomization (in terms of clustering results as well as computational time). 

The folder is structured as follows:

| Files/Folders                 | Description   |
| -----------------             | ------------- |
|1 data prep.R                  |R-script for data preparation/cleaning |
|2 Dexter.R                     |R-script for preliminary pscyhometric analyses using the `dexter` R package |
|3 MNLFA_cont.R                 |R-script for fitting the MNLFA using a continous background variable |
|3 MNLFA_dich.R                 |R-script for fitting the MNLFA using a dichotomized background variable |
|5 Compare models.R             |R-script for comparing the continous and dichotomous models on computational time and regularized parameters |
|6 Create clustering tables.R   |R-script for comparing the clustering results between the continous and dichotomous models  |
|/Figures                       |Folder with figures obtained in the preliminary analyses |
|/Find optimal reg par          |Folder containing the scripts used to find the optimal regularization parameter for each model |
|/RDS_objects                   |Folder with RDS objects created by running the R scripts|

## Ethics
Ethical approval for this study was provided by the Faculty Ethics Review Board (from the Faculty of Social & Behavioural Sciences at Utrecht University). The protocol reference numbers are 22-1892 (for the simulation study) and 23-0717 (for the PISA analyses). More information about the PISA data used in this study can be found in the [PISA 2015 Technical Report](https://www.oecd.org/pisa/data/2015-technical-report/). See also the [OECD Personal Data Protection page](https://www.oecd.org/general/data-protection.htm). 

## Contact
This repository will remain publicly available, it is managed by Lela Roos. For questions about this repository or the overall study, they can be contacted at l.a.roos(at)students.uu.nl. 

This thesis project was supervised by [Remco Feskens](https://www.cito.nl/kennis-en-innovatie/psychometrisch-onderzoek-en-dienstverlening/team/remco-feskens) and [Laura Kolbe](https://www.cito.nl/kennis-en-innovatie/psychometrisch-onderzoek-en-dienstverlening/team/laura-kolbe) at Cito.




