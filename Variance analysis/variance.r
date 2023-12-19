
###Variance analysis of Adonis, ANOSIM, MRPP, dbRDA methods
library(vegan)

metadata <- read.delim("metadata.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
otu_data <- read.delim("OTU_count.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
otu_data <- data.frame(t(otu_data))

colnames(metadata)


result_adonis = list()
result_mrpp = list()
result_anosim = list()
result_dbRDA = list()

for (i in 1:ncol(metadata) ) {
  
  print(i)
  print(names(metadata)[i])
  if(i %in% c(4:6)){
    index_null = which(metadata[,i]=="." | metadata[,i]=="0" | is.na(metadata[,i]))
  }else{
    index_null = which(metadata[,i]=="." | is.na(metadata[,i]))
  }
  
  if(length(index_null) == 0){
    data = otu_data
    meta_data_use = metadata
  }else{
    data = otu_data[-index_null,]
    meta_data_use = metadata[-index_null,]
  }
  
  result_adonis[[i]] = adonis2(data ~ as.factor(meta_data_use[,i]), permutations = 1000,data = meta_data_use,method = "bray")
  result_anosim[[i]] = anosim(data, as.factor(meta_data_use[,i]),permutations = 1000,distance = "bray")
  result_mrpp[[i]] = mrpp(data, as.factor(meta_data_use[,i]),permutations = 1000,distance = "bray")
  result_dbRDA[[i]] = capscale(data ~ as.factor(meta_data_use[,i]), data = meta_data_use,distance = "bray",add = TRUE)
}


print("calcute the R2 and P calue:")

adonis_R2 = array()
adonis_p = array()
anosim_R2 = array()
anosim_p = array()
mrpp_R2 = array()
mrpp_p = array()
for(i in 1:length(result_adonis)){
  
  print(i)
  adonis_R2[i] = result_adonis[[i]]$R2[1]
  adonis_p[i] = result_adonis[[i]]$`Pr(>F)`[1]
  
  anosim_R2[i] = result_anosim[[i]]$statistic
  anosim_p[i] = result_anosim[[i]]$signif
  
  mrpp_R2[i] = result_mrpp[[i]]$A
  mrpp_p[i] = result_mrpp[[i]]$Pvalue
  
}

factor = names(metadata)[1:ncol(metadata)]
print(factor)
data1 = data.frame(factor,adonis_R2,adonis_p,anosim_R2,anosim_p,mrpp_R2,mrpp_p)


dbrda_R2 = array()
dbrda_R2_adj = array()
dbrda_cca = list()
dbrda_p = array()
for (i in 1:length(result_dbRDA)) {
  
  dbrda_R2[i] = RsquareAdj(result_dbRDA[[i]])$r.squared
  print(dbrda_R2[i])
  dbrda_R2_adj[i] = RsquareAdj(result_dbRDA[[i]])$adj.r.squared
  print(dbrda_R2_adj[i])
  dbrda_cca[[i]] = anova.cca(result_dbRDA[[i]],permutations = 1000)
  dbrda_p[i] = dbrda_cca[[i]]$`Pr(>F)`[1]
  print(dbrda_p[i])
}

factor = names(metadata)[1:ncol(metadata)]
data2 = data.frame(factor,dbrda_R2,dbrda_R2_adj,dbrda_p)
data <- data.frame(data1, data2)
write.table(data,"data_method4_metadata.txt", sep = "\t", quote = F)




### adjust p value
adonis_all <- read.delim("data_method4_metadata.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
rownames(adonis_all) <- adonis_all$factor
adonis_all <- adonis_all[,-c(1,8)]


adonis_q = p.adjust(adonis_all$adonis_p,method="fdr",length(adonis_all$adonis_p))
anosim_q = p.adjust(adonis_all$anosim_p,method="fdr",length(adonis_all$anosim_p))
mrpp_q = p.adjust(adonis_all$mrpp_p,method="fdr",length(adonis_all$mrpp_p))
dbrda_q = p.adjust(adonis_all$dbrda_p,method="fdr",length(adonis_all$dbrda_p))

q_data = data.frame(adonis_all[,c(1,2)], adonis_q,
                    adonis_all[,c(3,4)], anosim_q,
                    adonis_all[,c(5,6)], mrpp_q, 
                    adonis_all[,c(7,8,9)], dbrda_q)
q_data$Group <- c("Demography", "Geography", "Geography", "Food","Food","Food","Nutrient","Nutrient","Physiological parameters","Physiological parameters")



index_q = which(adonis_q<0.05 & anosim_q<0.05 & mrpp_q<0.05 & dbrda_q<0.05)
factor_use <- factor[index_q]

reduce_q = q_data[factor_use,]
write.table(reduce_q, file = "data_method4_q.txt", sep = "\t", quote = F)



### plot the bar plot ###
library(ggplot2)
library(ggbreak)

factors_adonis = rownames(reduce_q)
r2_adonis = reduce_q$adonis_R2
q_adonis = reduce_q$adonis_q
group_adonis = reduce_q$Group

adonis_q = data.frame(factors_adonis, r2_adonis, q_adonis, group_adonis)
adonis_q = adonis_q[order(adonis_q[,2]),]

color = c("Geography" = "#00B2EE", "Demography" = "Gold","Food" = "#00A087FF", "Nutrient" = "#EE6363","Physiological parameters" = "#4682B4")

bar_adonis_q <- ggplot(data = adonis_q, mapping = aes(y = factor(factors_adonis, levels = factors_adonis), x = r2_adonis, fill = group_adonis))+
  geom_bar(stat = "identity") +
  scale_fill_manual(values=color,name = "Group")+
  labs(x = "Adonis R2", y = "Factors", title = "Adonis R2 of factors")+
  theme_classic() +
  theme(axis.text.x = element_text(angle = 75,hjust = 0.5,vjust = 0.5))+
  theme(plot.title = element_text(hjust = 0.5)) 


print(bar_adonis_q)

bar_adonis_q1 <- bar_adonis_q  + scale_x_break(c(0.015, 0.025), scales = 0.5) #+ scale_x_break(c(0.02, 0.04), scales=0.4)
bar_adonis_q1
ggsave(bar_adonis_q1, file="adonis.pdf",height = 6, width = 8)


