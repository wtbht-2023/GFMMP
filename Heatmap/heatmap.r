
### relationship among food, genera and metabolite


## the spearman result of food and metabolite, genus and metabolite
cor_food_metabolite_q005 <- read.delim("cor_food_metabolite_q005.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)

cor_genus_metabolite_q005 <- read.delim("cor_genus_metabolite_q005.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)

cor_food_metabolite <- read.delim("cor_food_metabolite.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
q_food_metabolite <- read.delim("q_food_metabolite.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)


cor_genus_metabolite <- read.delim("cor_genus_metabolite.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)
q_genus_metabolite <- read.delim("q_genus_metabolite.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)


metabolite_name <- data.frame(intersect(cor_food_metabolite_q005$chemical_name, cor_genus_metabolite_q005$chemical_name))
colnames(metabolite_name) <- "metabolite_name"

metabolite_name <- metabolite_name$metabolite_name

cor_food_metabolite_q005 <- cor_food_metabolite_q005[which(cor_food_metabolite_q005$chemical_name %in% metabolite_name),]
cor_genus_metabolite_q005 <- cor_genus_metabolite_q005[which(cor_genus_metabolite_q005$chemical_name %in% metabolite_name),]

food_name <- unique(cor_food_metabolite_q005$food)
genus_name <- unique(cor_genus_metabolite_q005$genus)
food_genus_metabolite_use <- cbind(food_name, genus_name, metabolite_name)

cor_food_metabolite_use <- data.frame(t(cor_food_metabolite[food_name, metabolite_name]))
q_food_metabolite_use <- data.frame(t(q_food_metabolite[food_name, metabolite_name]))

cor_genus_metabolite_use <- data.frame(t(cor_genus_metabolite[genus_name, metabolite_name]))
q_genus_metabolite_use <- data.frame(t(q_genus_metabolite[genus_name, metabolite_name]))



### 画热图
library(ComplexHeatmap)
library(circlize)
library(RColorBrewer)


col_metabolite_food <- colorRamp2(c(min(cor_food_metabolite_use), 0, max(cor_food_metabolite_use)), c("#0066CC", "white", "#FF6600"))
ht11 <- Heatmap(cor_food_metabolite_use, name = "metabolite_Food", col = col_metabolite_food,
                cell_fun = function(j, i, x, y, width, height, fill){
                  grid.text(sprintf("%s", q_food_metabolite_use[i, j]), x, y, gp = gpar(fontsize = 10))
                })



col_metabolite_genus <- colorRamp2(c(min(cor_genus_metabolite_use), 0, max(cor_genus_metabolite_use)), c("#3A5FCD", "white", "#CD5555"))
ht12 <- Heatmap(cor_genus_metabolite_use, name = "metabolite_Genus", col = col_metabolite_genus,
                cell_fun = function(j, i, x, y, width, height, fill){
                  grid.text(sprintf("%s", q_genus_metabolite_use[i, j]), x, y, gp = gpar(fontsize = 10))
                })


ht <- ht11 + ht12
draw(ht)



