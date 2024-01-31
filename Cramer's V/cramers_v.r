
### cramers'v analysis between geography and factors
library(DescTools)


metadata <- read.delim("metadata.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
sample <- rownames(metadata)

colnames(metadata)


##factor: significant result of adonis
factor_name <- colnames(metadata)[-c(6,9)]
factor_data <- metadata[, factor_name]




### cramer’s V #####
colnames(factor_data)
geography_data <- factor_data[,c(2,3)]
index_data <- factor_data[,-c(2,3)]
index_name <- names(index_data)


cramer_factor <- function(index, name){
  chisq_data <- list()
  p_value <- array()
  chi2 <- array()
  v <- array()
  
  for (i in 1:ncol(index_data)) {
    # i=1
    # index=1
    index_na <- which(index_data[,i] == "." | is.na(index_data[,i]))
    if(length(index_na) > 0){
      mytable <- table(geography_data[-index_na, index],index_data[-index_na, i])
    }else{
      mytable <- table(geography_data[, index],index_data[, i])
    }
    
    n <- sum(mytable)
    q <- min(nrow(mytable), ncol(mytable))
    chisq_data[[i]] <- chisq.test(mytable, correct = FALSE)
    p_value[i] <- chisq_data[[i]]$p.value
    chi2[i] <- unname(chisq_data[[i]]$statistic)
    v[i] <- sqrt(chi2[i]/(n*(q-1))) 
    
  }
  
  factor_cramer <- data.frame(index_name, p_value, chi2, v)
  write.table(factor_cramer, file = paste0(name,"_cramer.txt"), sep = "\t", row.names = F, quote = F)
  
}


cramer_factor(1, "Province")
cramer_factor(2, "Region")




###cramer's V  result of all factor
cramer_v_index <- matrix(nrow = length(index_name), ncol = length(index_name))
cramer_p_index <- matrix(nrow = length(index_name), ncol = length(index_name))
cramer_chi2_index <- matrix(nrow = length(index_name), ncol = length(index_name))
for (i in 1:length(index_name)) {
  for (j in 1:(length(index_name))) {
    index_na1 <- which(is.na(index_data[,i]) | index_data[,i] == ".")
    index_na2 <- which(is.na(index_data[,j]) | index_data[,j] == ".")
    index_na <- unique(index_na1,index_na2)
    if(length(index_na) > 0){
      mytable <- table(index_data[-index_na, i],index_data[-index_na, j])
    }else{
      mytable <- table(index_data[, i],index_data[, j])
    }
    
    n <- sum(mytable)
    q <- min(nrow(mytable), ncol(mytable))
    chisq_data <- chisq.test(mytable, correct = FALSE)
    cramer_p_index[i,j] <- chisq_data$p.value
    cramer_chi2_index[i,j] <- unname(chisq_data$statistic)
    cramer_v_index[i,j] <- sqrt(cramer_chi2_index[i,j]/(n*(q-1))) 
  }
  
}
colnames(cramer_v_index) <- index_name
rownames(cramer_v_index) <- index_name
write.table(cramer_v_index, file = "cramer_v_index.txt", sep = "\t", quote = F)

colnames(cramer_chi2_index) <- index_name
rownames(cramer_chi2_index) <- index_name
write.table(cramer_chi2_index, file = "cramer_chi2_index.txt", sep = "\t", quote = F)

colnames(cramer_p_index) <- index_name
rownames(cramer_p_index) <- index_name
write.table(cramer_p_index, file = "cramer_p_index.txt", sep = "\t", quote = F)



#### plot the result of geography factor and significant factors
library(corrplot)
library(RColorBrewer)

geography_name <- c("Province", "Region")

cramer_v_all <- array()
cramer_p_all <- array()
for (i in 1:length(geography_name)) {
  data_cramer <- read.table(paste0(geography_name[i],"_cramer.txt"), sep = "\t", header = T)
  cramer_v_all <- cbind(cramer_v_all, data_cramer$v)
  cramer_p_all <- cbind(cramer_p_all, data_cramer$p_value)
}

cramer_v_all <- cramer_v_all[,-1]
cramer_p_all <- cramer_p_all[,-1]
colnames(cramer_v_all) <- geography_name
rownames(cramer_v_all) <- index_name
colnames(cramer_p_all) <- geography_name
rownames(cramer_p_all) <- index_name

cramer_v_all <- t(cramer_v_all)
cramer_p_all <- t(cramer_p_all)
factor_order <- data.frame(t(cramer_v_all))

### factor order
factor_index <- data.frame(factors = index_name,
                           group = c("Demography", "Food", "Food", "Nutrient","Nutrient","Physiological parameters"))

factor_order$factor <- rownames(factor_order)
factor_order <- merge(factor_order, factor_index, by.x = "factor", by.y = "factors")
factor_order <- factor_order[order(factor_order$group, -factor_order$Province),]
factor_orders <- factor_order$factor

write.table(factor_order, file = "factor_order.txt", sep = "\t", quote = F)


cramer_v_all <- cramer_v_all[, factor_orders]
cramer_p_all <-cramer_p_all[, factor_orders]
write.table(cramer_v_all, "cramer_v_factor_index.txt", sep = "\t", quote = F)
write.table(cramer_p_all, "cramer_p_factor_index.txt", sep = "\t", quote = F)
pdf(file = "factor_index_cramer_new.pdf", width = 12, height = 8 )
corrplot(corr = cramer_v_all, p.mat = cramer_p_all, method = "circle", 
         pch.cex = 0.5, #cl.pos = "n",
         cl.length = 4,cl.ratio = 0.1,
         # col = brewer.pal(n = 10, name = 'Dark2'),
         # tl.col = "black", col.lim = c(0,0.6)
         )
dev.off()





#### result of geography and food factors
library(reshape2)
library(dplyr)

food_factor <- factor_index$factors[which(factor_index$group == "Food")]
cramer_p_df <- melt(cramer_p_all[, food_factor], id.vars="x", variable.name="y")
cramer_v_df <- melt(cramer_v_all[, food_factor], id.vars="x", variable.name="y")
cramer_df <- data.frame(cramer_v_df, cramer_p_df$value)
colnames(cramer_df) <- c( "geography","factor", "cramer_v", "p_value")
cramer_df_reduce <- filter(cramer_df, p_value < 0.05)
cramer_df_reduce <- filter(cramer_df_reduce, cramer_v > 0.2)

write.table(cramer_df_reduce, file = "cramer_df_reduce_geography_factor.txt", sep = "\t", quote = F)




library(ggcor)
library(dplyr)
library(ggplot2)

## example data used all food factors to plot the result
cramer_df_reduce <- cramer_df
cramer_df <- cramer_df_reduce %>%
  mutate(r_value = cut(as.numeric(cramer_v), breaks = c(-Inf, 0.2, 0.3, Inf), 
                       labels = c('<0.2', '0.2-0.3', '>=0.3'), right = FALSE),
         q_value = cut(as.numeric(p_value), breaks = c(-Inf, 0.001, 0.01, 0.05, Inf), 
                       labels = c('<0.001', '0.001-0.01', '0.01-0.05', '>=0.05'), right = FALSE))
write.table(cramer_df, file = "cramer_df_quickcor_new.txt", sep = "\t", quote = F)

cramer_v_index <- read.delim("cramer_v_index.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
food_factor <- unique(cramer_df_reduce$factor)
df_food_cramer <- cramer_v_index[food_factor, food_factor]
for (i in 1:nrow(df_food_cramer)) {
  df_food_cramer[i,i] = 0
}

pdf(file = "quickcor_factor_index_cramer_new.pdf", width = 20, height = 18 )
quickcor(df_food_cramer, type = "upper") +
  geom_square() +
  anno_link(aes(colour = q_value, size = r_value), data = cramer_df) +
  scale_size_manual(values = c(0.5, 1.5, 3)) +
  scale_fill_gradient2(midpoint = 0, low = "white", mid = "white",
                       high = "#E69F00", space = "Lab" ) +  ### 矩阵颜色our_manual(values = c("#1B9E77","#A2A2A288", "#D95F02")) + 
  guides(size = guide_legend(title = "Cramer's v",
                             override.aes = list(colour = "grey35"), 
                             order = 2),
         colour = guide_legend(title = "Cramer's p", 
                               override.aes = list(size = 3), 
                               order = 1),
         fill = guide_colorbar(title = "Cramer's V of Factors", order = 3))
dev.off()
