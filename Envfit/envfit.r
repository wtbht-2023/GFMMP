##the envfit analysis between age group and genera which was filtered in maaslin analysis



library(vegan)


genus_data <- read.delim("genus_data.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F) 

Age_group <- read.delim("age_info.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)


data_env <- data.frame(t(genus_data), Age_group$Age3)
data <- data_env[,-ncol(data_env)]

ord = data.frame(cmdscale(dist(data),k=2))
colnames(ord) = c('X1','X2')  
envfit_result = envfit(ord, data_env, permutations = 999, na.rm = TRUE)
p_values <- envfit_result$vectors$pvals 
centroids <- envfit_result$vectors$arrows  


envfit_data <- data.frame(p_values = p_values, centroids = centroids)
write.table(envfit_data, file = "envfit_pvalue.txt", sep = "\t", quote = F)


envfit_p <- envfit_data[which(envfit_data$p_values < 0.05), ]
write.table(envfit_p, file = "envfit_pvalue_005.txt", sep = "\t", quote = F)




### showing the relationship between age and genera

library(corrplot)
library(dplyr)
library(ggplot2)

fastspar_data <- read.delim("fastspar_data.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
genus_fastspar <- unique(c(fastspar_data$genus_name.x, fastspar_data$genus_name.y))

genus_envfit <- rownames(envfit_data)

genus_envfit %in% genus_fastspar
genus_use <- genus_fastspar
envfit_data <- envfit_data[genus_use, ]



cor <- matrix(0, nrow = length(genus_use), ncol = length(genus_use))
rownames(cor) = genus_use
colnames(cor) = genus_use
for (i in 1:nrow(fastspar_data)) {
  cor[fastspar_data$genus_name.x[i], fastspar_data$genus_name.y[i]] = fastspar_data$cor_cdata[i]
}

 
## the matrix
for(i in 2:length(genus_use)){
  for (j in 1:(i-1)) {
    if(cor[i,j] != 0){
      cor[j,i] = cor[i,j]
      cor[i,j] = 0
    }
  }
}

for (i in 2:length(genus_use)) {
  for (j in 1:(i-1)) {
    cor[i,j] = cor[j,i]
  }
}


envfit_data <- data.frame(rownames(envfit_data), envfit_data)
envfit_data <- data.frame(rep("Age", nrow(envfit_data)), envfit_data)
colnames(envfit_data)[1:2] <- c("Age", "Genus")
df <- envfit_data %>%
  mutate(p_value = cut(as.numeric(p_values), breaks = c(-Inf, 0.01, 0.05, Inf), 
                       labels = c('<0.01', '0.01-0.05', '>=0.05'), right = FALSE))
# df <- df[genus_order, ]
df$subx <- rep(-3, nrow(df))
df$suby <- rep(7, nrow(df))
df$x <- rep(0:(length(genus_use) - 1) - 0.5)
df$y <- rep(length(genus_use):1)
df$col <- as.character(df$p_value)
df$col[which(df$p_value == "<0.01")] = "#1B9E77"
df$col[which(df$p_value == "0.01-0.05")] = "#D95F02"
df$col[which(df$p_value == ">=0.05")] = "gray"


write.table(df, file = "df_corplot.txt", sep = "\t", quote = F)

df$subx <- as.numeric(df$subx)
df$suby <- as.numeric(df$suby)
df$y <- as.numeric(df$y)

class(df$y)
corrplot(cor, method = "color", type = "upper", addrect = 1, insig = "blank", order = "hclust",hclust="complete",
         rect.col = "blue", rect.lwd = 2, tl.col = "black",tl.srt = 45) 

segments(as.numeric(df$subx), as.numeric(df$suby), as.numeric(df$x), as.numeric(df$y), lty = 'solid', col = df$col, xpd = TRUE)
points(as.numeric(df$subx), as.numeric(df$suby), pch = 24, col = 'blue', bg = 'blue', cex = 2, xpd = TRUE)
text(as.numeric(df$subx) - 0.5, as.numeric(df$suby), labels = df$Age, adj = c(0.8, 0.5), cex = 1.2, xpd = TRUE) 


