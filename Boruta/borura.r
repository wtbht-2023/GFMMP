library(Boruta)
library(ggplot2)
library(pheatmap)

metadata <- read.delim("metadata.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
sample <- rownames(metadata)

food_name <- c("Rice", "Fruit")
relative_genus = read.delim("genus_data.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)


metadata_use <- metadata[, food_name]

for (i in 1:ncol(metadata_use)) {
  print(i)
  group_name <- colnames(metadata_use)[i]
  print(group_name)
  group <- factor(metadata_use[,i])
  
  train_data <- data.frame(t(relative_genus[,sample]), group)
  train_data <- na.omit(train_data)
  boruta.train <- Boruta(group~., data = train_data, doTrace = 2,ntree = 500)
  print(boruta.train)
  final.boruta <- TentativeRoughFix(boruta.train)
  
  print(final.boruta)
  
  
  boruta.df <- attStats(final.boruta)
  write.table(boruta.df,paste0(group_name, "/boruta_", group_name, ".txt"), sep = "\t", quote = F)
  write.table(final.boruta$ImpHistory,paste0(group_name, "/boruta_", group_name,"_ImpHistory.txt"), sep = "\t", quote = F)
  
}



for (i in 1:ncol(metadata_use)) {
  
  print(i)
  group_name = colnames(metadata_use)[i]
  print(group_name)
  group = factor(metadata_use[,i])
  
  importance_data = read.table(paste0(group_name, "/boruta_", group_name,"_ImpHistory.txt"), sep = "\t", header = T, check.names = F, stringsAsFactors = F)
  colnames(importance_data) <- gsub("WPS.1", "WPS-1", colnames(importance_data) )
  colnames(importance_data) <- gsub("Escherichia.Shigella", "Escherichia/Shigella", colnames(importance_data) )
  # importance_data = importance_data[,-1]
  boruta.df = read.table(paste0(group_name, "/boruta_", group_name, ".txt"), sep = "\t", header = T, check.names = F, stringsAsFactors = F)
  confirmed_all = rownames(boruta.df)[which(boruta.df$decision == "Confirmed")]
  
  confirmed = c(confirmed_all,"shadowMin","shadowMean","shadowMax")
  confirmed = gsub("WPS.1", "WPS-1", confirmed)
  importance_data = importance_data[,confirmed]
  Labels <- sort(sapply(importance_data,median))
  importance_data = importance_data[,names(Labels)]
  confirmed = names(Labels)[-which(names(Labels)=="shadowMin" | names(Labels)== "shadowMean"| names(Labels)== "shadowMax")]
  
  
  if(length(confirmed)>1){
    importance = c()
    for (j in 1:length(confirmed)) {
      # i=1
      index = which(colnames(importance_data) == confirmed[j])
      importance = c(importance,as.numeric(importance_data[,index]))
    }
    # importance = importance[-1]
    importance = c(importance_data[,which(names(Labels)=="shadowMin")],importance_data[,which(names(Labels)=="shadowMean")],importance_data[,which(names(Labels)=="shadowMax")],importance)
    genus_name = rep(c("shadowMin","shadowMean","shadowMax",confirmed),c(rep(99,(length(confirmed)+3))))
    
    group = rep(c("shadowMin","shadowMean","shadowMax","confirmed"),c(99,99,99,(99*length(confirmed))))
    
    df = data.frame(
      genus_name,
      importance,
      group
    )
    
    write.table(df, file = paste0(group_name, "/", group_name, "_importance_genus.txt"), sep = "\t", quote = F)
    color = c("shadowMin"="#1874CD","shadowMean" = "#1874CD","shadowMax" = "#1874CD","confirmed"= "#9ACD32")
    
    
    box <- ggplot(df, aes(x = factor(genus_name,levels = c("shadowMin","shadowMean","shadowMax",confirmed)),y=importance))+
      geom_boxplot(aes(fill=group))+
      labs(x ="genus", y = "Importance")+
      theme(plot.title = element_text(hjust = 0.5))+
      scale_fill_manual(values=color)+
      # guides(fill=FALSE)+  
      theme(axis.text.x = element_text(angle = 90,hjust = 1,vjust = 1.0))##坐标轴标题纵向显示
    print(box)
    # dev.off()
    ggsave(box,file=paste0(group_name, "/box_",group_name,".pdf"),width = 20,height = 10)
    
  }
  
}


### heatmap of all result
data_all <- c()
for (i in 1:ncol(metadata_use)) {
  # i=1
  group_name = colnames(metadata_use)[i]
  boruta_data = read.table(paste0(group_name, "/boruta_", group_name, ".txt"), sep = "\t", header = T, check.names = F, stringsAsFactors = F)
  confirmed_all = rownames(boruta_data)[which(boruta_data$decision == "Confirmed")]
  confirmed_all = gsub("WPS.1", "WPS-1", confirmed_all)
  importance_data <- read.table(paste0(group_name, "/", group_name, "_importance_genus.txt"), sep = "\t", header = T, check.names = F, stringsAsFactors = F)
  importance_median <- aggregate(importance_data$importance, by = list(importance_data$genus_name), FUN = "median")
  rownames(importance_median) <- importance_median$Group.1
  importance_median <- importance_median[confirmed_all,]
  median_data <- importance_median[confirmed_all,2]
  food <- rep(group_name, length(confirmed_all))
  data <- data.frame(confirmed_all, food, median_data)
  data_all <- rbind(data_all, data)
  
}

data_all <- data_all[-grep("Gp", data_all$confirmed_all), ]
data_all <- data_all[-which(data_all$confirmed_all == "Others"), ]
write.table(data_all, file = "data_all_boruta.txt", sep = "\t", quote = F)


genus_all <- unique(data_all$confirmed_all)
heat_data <- matrix(nrow = length(genus_all), ncol = length(food_name))
rownames(heat_data) <- genus_all
colnames(heat_data) <- food_name

for (i in 1:nrow(data_all)) {
  
  genus1 <- data_all$confirmed_all[i]
  food1 <- data_all$food[i]
  heat_data[genus1, food1] <- data_all$median_data[i]
}

heat_data[which(is.na(heat_data), arr.ind = T)] = 0

p <- pheatmap(heat_data,  show_rownames = T, cluster_rows = T, cluster_cols = F, border_color = NA, #display_numbers = number_heat,
              color = colorRampPalette(c("white", "DarkRed"))(30))
p
ggsave(p,file=paste0("heatmap_genus_food_boruta.pdf"), width = 8, height = 20)



