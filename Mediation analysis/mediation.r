
## the mediation analysis among geography info, food and genera,
## all data were Normalized

library(mediation)


geography_info <- read.delim("geography_info_use.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
genus_data <- read.delim("genus_use_data.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
food_data <- read.delim("food_data_use.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
metadata_general <- read.delim("metadata_general_use.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)


for (i in 1:2) {
  i=1
  print(c("i=", i))
  ACME_Estimate <- c()
  ACME_CI_lower <- c()
  ACME_CI_upper <- c()
  ACME_p <- c()
  
  ADE_Estimate <- c()
  ADE_CI_lower <- c()
  ADE_CI_upper <- c()
  ADE_p <- c()
  
  Total_Effect_Estimate <- c()
  Total_Effect_CI_lower <- c()
  Total_Effect_CI_upper <- c()
  Total_Effect_p <- c()
  
  Prop_Mediated_Estimate <- c()
  Prop_Mediated_CI_lower <- c()
  Prop_Mediated_CI_upper <- c()
  Prop_Mediated_p <- c()
  
  genus_name <- c()
  food_name <- c()
  
  index1 <- which(is.na(as.numeric(geography_info[,i])))
  
  for (j in 1:nrow(genus_data)) {
    # j=1
    print(j)
    
    for (k in 1:ncol(food_data)) {
      # k=1
      index2 <- which(is.na(as.numeric(food_data[,k])))
      index <- c(index1, index2)
      
      food_name <- c(food_name, colnames(food_data)[k])
      genus_name <- c(genus_name, rownames(genus_data)[j])
      if(length(index) != 0 ){
        df <- data.frame(food = as.numeric(food_data[-index,k]), geography = as.numeric(geography_info[-index,i]),  
                         factor1 = as.numeric(metadata_general$Age[-index]), factor2 = as.numeric(metadata_general$Gender[-index]), 
                         factor3 = as.numeric(geography_info[-index, 2]),
                         genus = as.numeric(genus_data[j,-index]))
        
      }else{
        df <- data.frame(food = as.numeric(food_data[,k]), geography = as.numeric(geography_info[,i]),  
                         factor1 = as.numeric(metadata_general$Age), factor2 = as.numeric(metadata_general$Gender), 
                         factor3 = as.numeric(geography_info[, 2]),
                         genus = as.numeric(genus_data[j,]))
        
      }
      
      geography_food <- glm(food ~ geography + factor1 + factor2 + factor3, data = df)
      geography_genus <- glm(genus ~ geography + food + factor1 + factor2 + factor3, data = df)
      contcont <- mediate(geography_food, geography_genus, sims=1000, treat="geography", mediator="food")
      
      
      cont_list <- summary(contcont)
      
      ACME_Estimate <- c(ACME_Estimate, cont_list$d0) ##ACME
      ACME_CI_lower <- c(ACME_CI_lower, cont_list$d0.ci[1])
      ACME_CI_upper <- c(ACME_CI_upper, cont_list$d0.ci[2])
      ACME_p <- c(ACME_p, cont_list$d0.p)
      
      ADE_Estimate <- c(ADE_Estimate, cont_list$z0) ##ADE
      ADE_CI_lower <- c(ADE_CI_lower, cont_list$z0.ci[1])
      ADE_CI_upper <- c(ADE_CI_upper, cont_list$z0.ci[2])
      ADE_p <- c(ADE_p, cont_list$z0.p)
      
      
      Total_Effect_Estimate <- c(Total_Effect_Estimate, cont_list$tau.coef)  ##Total Effect
      Total_Effect_CI_lower <- c(Total_Effect_CI_lower, cont_list$tau.ci[1])
      Total_Effect_CI_upper <- c(Total_Effect_CI_upper, cont_list$tau.ci[2])
      Total_Effect_p <- c(Total_Effect_p, cont_list$tau.p)
      
      
      Prop_Mediated_Estimate <- c(Prop_Mediated_Estimate, cont_list$n0) ##Prop. Mediated
      Prop_Mediated_CI_lower <- c(Prop_Mediated_CI_lower, cont_list$n0.ci[1])
      Prop_Mediated_CI_upper <- c(Prop_Mediated_CI_upper, cont_list$n0.ci[2])
      Prop_Mediated_p <- c(Prop_Mediated_p, cont_list$n0.p)
    }
    
    
  }
  df_mediation <- data.frame(food_name, genus_name, 
                             ACME_Estimate, ACME_CI_lower, ACME_CI_upper, ACME_p,
                             ADE_Estimate, ADE_CI_lower, ADE_CI_upper, ADE_p,
                             Total_Effect_Estimate,Total_Effect_CI_lower, Total_Effect_CI_upper, Total_Effect_p,
                             Prop_Mediated_Estimate, Prop_Mediated_CI_lower, Prop_Mediated_CI_upper, Prop_Mediated_p)
  
  
  write.table(df_mediation, file = paste0(colnames(geography_info)[i], "_mediation_info_correct.txt"), sep = "\t", quote = F)
  
}


