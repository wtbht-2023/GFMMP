# GFMMP 

The linkage of geography location, diet, gut  microbiome, serum metabolites and physiological index in a Chinese population.

## 1.Variance analysis 

This folder describes the variance analysis of Adonis, ANOSIM, MRPP, dbRDA methods, based on bray_curtis distance to evaluate the relationship between variables and gut microbiome. 

### Data files: 

* variance.r: the methods of Adonis, ANOSIM, MRPP, dbRDA, and a result of bar plot is printed. 
* OTU_count.txt: the input data.
* metadata.txt: the variance of this study, which includes geography, demography, food, nutrient and physiological parameters. 

## 2.Distance of samples 
The northernmost resident is selected to calculate Bray-Curtis distance and Pearson values to the other individuals. The results of linear regression among real distance, Bray-Curtis distance and Pearson values are plot in pictures. 

### Data files:
* distance_lm.r: the results of linear regression. 
* distance_info.txt: the distance infomation among individuals.

## 3.Map 
Alpha diversity result is ploted in map. 

### Data files: 
* alpha_map.r: the result of alpha diversity in map. 
* alpha_province.txt: the alpha diversity of 15 provinces. 
* province_mid.xlsx: the map center coordinates of provinces.  
* your_data.xlsx: the map information of provinces.

## 4.Maaslin analysis
The maaslin analysis of province microbiome. The different genera between one province and other fourteen provinces are calculated among 15 provinces respectively. 

### Data files: 
* maaslin.r: the maaslin method of each province. 
* genus_data.txt: the relative abundance of genera data of each individuals in 15 provinces as the input data, the rows are information of genera, and columns are samples. 
* metadata.txt: the variance of this study as the metadata. 

## 5.specific genera
After maaslin analysis, the genera that differ from more than two-thirds of the provinces were defined as the specific genera in each province.

### Data files: 
* specific_genera.r: the detail method of filtering specific genera. 

## 6.Cramer's V
Cramer's V analysis among all factors. In this example data, geography factors include Province and Region. After calculating the value of cramer's V, we use the quickcor function in ggcor packages to draw a picture and show the relationship between factors.

### Data files: 
* cramers_v.r: the Cramer's V analysis.  
* metadata.txt: the variance of this study including geography, demography, food, nutrient and physiological parameters.

## 7.Boruta
The Boruta analysis of food factors and genera data of all samples. The Boruta function of Boruta package is implemented to sift the genera related to food groups. The sifted genera and food factors are showed in a heatmap through pheatmap function.

### Data files: 
* borura.r: the Boruta analysis of food factors and genera data of all samples
* genus_data.txt: the relative abundance of genera data of each individuals in 15 provinces. 
* metadata.txt: the variance of this study. 

## 8.Mediation analysis 
The mediation analysis among geography, food and genera data, and all data we used were Normalized. We uses the glm model and mediate function to structure a model with the food as the mediator. 
### Data files: 
* mediation.r: the mediation analysis among geography, food and genera data. 
* food_data_use.txt: the food information, the rows are samples and the columns are the food factors. 
* genus_use_data.txt: the relative abundance of genera data of each samples. 
* geography_info_use.txt: the Latitude and Longitude information of each samples. 
* metadata_general_use.txt: the Gender and Age information of each samples, which as the corrected factors.

## 9.Heatmap  
The relationship among food, genera and metabolite. The correlation coefficient (cor) and significance p-value between food and metabolite, genera and metabolite, were obtained through Spearman correlation analysis. The results among the three are drawn through ComplexHeatmap package. 

### Data files: 
* heatmap.r: the heatmap results among food, genera and metabolite. 
* cor_food_metabolite.txt: the cor value between food and metabolite.
* cor_food_metabolite_q005.txt: the filtered results of cor value, p-value and adjusted p-value with adjusted p-value < 0.05 between food and metabolite.
* cor_genus_metabolite.txt: the cor value between genera and metabolite.
* cor_genus_metabolite_q005.txt: the filtered results of cor value, p-value and adjusted p-value with adjusted p-value < 0.05 between genera and metabolite.
* q_food_metabolite.txt: the adjusted p-value between food and metabolite.
* q_genus_metabolite.txt: the adjusted p-value between genera and metabolite.

## 10.Envfit  
The envfit analysis between age group and genera which was filtered in maaslin analysis. We use the envfit function of vegan package to filter the genera which related to age group, and the fastspar software to calculate the correlation among genera. The corrplot function of corrplot package to show the results.
### Data files: 

* envfit.r：the envfit analysis between age group and genera and the results picture. 
* age_info.txt: the age group of samples. 
* envfit_pvalue.txt: the p-value of envfit results between age group and genera. 
* envfit_pvalue_005.txt: the filtered results with p-value = 0.05. 
* fastspar_data.txt：the fastspar results among genera. 
* genus_data.txt：the relative abundance of genera data of each samples.

## 11.RF 
The randomForest analysis is carried out according to differential genera which filtered with MaAsLin analysis, and the leave-one-out cross validation is used to predict the age of each individual. Furthermore, the regression results between the actual age and the predicted age are displayed.

### Data files: 
* RF.r: the randomForest analysis and the results picture.
* Age_info.txt: the age information of samples. 
* genus_data.txt: the relative abundance of differential genera data of each samples. 


## Attention  
The data uploaded in this project is all example data. The codes uploaded in this project are the implementation of the methods and the output of the result image.
