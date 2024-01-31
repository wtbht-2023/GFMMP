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



## Attention  
The data uploaded in this project is all example data. The codes uploaded in this project are the implementation of the methods and the output of the result image.
