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

## Attention  
The data uploaded in this project is all example data. The codes uploaded in this project are the implementation of the methods and the output of the result image.
