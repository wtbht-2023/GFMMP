
####  specific genera in 15 provinces 

## filter results: q<0.01

province_name = c("HLJ","LN","SD","JS","ZJ","SH","BJ","SX","HeN","HB","HN","CQ","GZ","YN","GX")

genus_inter <-c()
genus_union <- c()
for (i in 1:length(province_name)) {
  # i=1
  data1 <- read.delim(paste0("province_", province_name[i], "/all_results.tsv"), sep = "\t", header = T, check.names = F, stringsAsFactors = F)
  data1 <- data1[which(data1$qval < 0.01), ]
  
  write.table(data1, file = paste0("province_", province_name[i], "/filter_q001_results.txt"), sep = "\t", quote = F)
  
  
  genus <- unique(data1$feature)
  
  if(i == 1){
    genus_inter <- genus
    genus_union <- genus
  }else{
    genus_inter <- intersect(genus_inter, genus)
    genus_union <- union(genus_inter, genus)
  }
}

length(genus_inter) 
length(genus_union) 


genus_province <- read.delim("genus_province_mean.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)


for (i in 1:length(province_name)) {
  # i=11
  data1 <- read.delim(paste0("province_", province_name[i], "/filter_q001_results.txt"), sep = "\t", header = T, check.names = F, stringsAsFactors = F)
  
  index <- which(data1$feature == "Escherichia.Shigella")
  if(length(index) != 0){
    data1$feature[index] = "Escherichia/Shigella"
  }
  
  ## foldChange
  
  data1$logFC <- rep(0, nrow(data1))
  for (j in 1:nrow(data1)) {
    genus1 <- data1$feature[j]
    province1 <- data1$value[j]
    data1$logFC[j] <- log2(genus_province[province_name[i],genus1] / genus_province[province1, genus1])
  }
  data1 <- data1[which(data1$logFC < -1 | data1$logFC > 1), ]
  
  write.table(data1, file = paste0("province_", province_name[i], "/filter_q001_fc_results.txt"), sep = "\t", quote = F)
  
  
  ##filtered results: log（FC）>1 or <-1, more than 2/3 provinces
  genus <- unique(data1$feature)
  provinces <- unique(data1$value)
  
  
  
  index_matrix <- matrix(0, nrow = length(genus), ncol = length(provinces))
  rownames(index_matrix) <- genus
  colnames(index_matrix) <- provinces
  
  for (k in 1:nrow(data1)) {
    index_matrix[data1$feature[k], data1$value[k]] = 1
  }
  index_matrix <- as.data.frame(index_matrix)
  index_matrix$sum <- rowSums(index_matrix)
  write.table(index_matrix, file = paste0("province_", province_name[i], "/genus_province_num_results.txt"), sep = "\t", quote = F)
  
  genus_unique <- index_matrix[which(index_matrix$sum >= 10),]
  genus_unique_data <- data.frame(genus_province[, rownames(genus_unique)])
  rownames(genus_unique_data) <- rownames(genus_province)
  colnames(genus_unique_data) <- rownames(genus_unique)
  
  
  write.table(genus_unique_data, file = paste0("province_", province_name[i], "/genus_unique_results.txt"), sep = "\t", quote = F)
  
}



