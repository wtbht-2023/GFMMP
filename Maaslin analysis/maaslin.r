

### maaslin analysis of province microbiome


library(Maaslin2)



metadata = read.table("metadata.txt", sep="\t", header = T, check.names = F, stringsAsFactors = F)
sample = rownames(metadata)

relative_genus = read.delim("genus_data.txt", sep="\t", header = T, check.names = F, stringsAsFactors = F)
relative_genus <- relative_genus[,sample]

### adjust factors
factors <- c("Province_name","Gender")


genus = rownames(relative_genus) 
input_data = relative_genus[genus,sample]
input_metadata = metadata[,factors]
input_metadata  <- as.data.frame(input_metadata)

### reduce the null data
index_null <- c()
for (k in 1:length(factors)) {
  index_null = c(index_null, which(metadata[,factors[k]]=="." | is.na(metadata[,factors[k]])))
}
index_null <- unique(index_null)
print(index_null)

if(length(index_null) > 0){
  input_metadata <- input_metadata[-index_null,]
  input_data <- input_data[,-index_null]
  
}


## set the column of matedata as a factor
input_metadata$Province_name <- factor(input_metadata$Province_name)
input_metadata$Gender <- factor(input_metadata$Gender)

province_names <- unique(metadata$Province_name)
i=2
### maaslin of 15 province genera
for (j in 1:length(province_names)) {
  fit_data <- Maaslin2(
    as.matrix(input_data), input_metadata, paste0("province_",province_names[j]), 
    transform = "AST",
    fixed_effects = colnames(metadata)[i], 
    reference = paste0(colnames(metadata)[i],",",province_names[j]),
    random_effects = c('Gender'),
    normalization = 'NONE',
    standardize = FALSE)
}

