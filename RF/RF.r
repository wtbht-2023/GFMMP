library(randomForest)

## RF analysis

Age_info <- read.delim("Age_info.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)

relative_genus = read.delim("genus_data.txt", sep="\t", header = T, check.names = F, stringsAsFactors = F)
relative_genus <- data.frame(t(relative_genus))

relative_genus$Age <- Age_info$Age
genus <- rownames(genus_use)

data.pred <- array()
for (i in 1:nrow(relative_genus)) {
  # i=1
  print(i)
  traindata<- relative_genus[-i,]
  traindata$Age = as.numeric(traindata$Age)
  data.rf <- randomForest(Age ~ .,traindata, ntree = 1000,importance = TRUE, mtry = round(sqrt(length(genus))) )##注意因变量必须为因子型数据
   
  testdata <- relative_genus[i,]
  testdata$Age <- as.numeric(testdata$Age)
  data.pred[i] <- predict(data.rf, testdata)
}

write.table(data.pred, file = "data_pred.txt", sep = "\t", quote = F)



Age_data <- relative_genus$Age


temp <- data.pred - Age_data
MAE = mean(abs(temp))


RF_pred<- data.frame(data.pred, Age_data, temp)

### plot the result
library(ggplot2)
df <- data.frame(Actual = Age_data, Predict = data.pred)

summary_age <- summary(lm(df$Predict ~ df$Actual))
a = summary_age$coefficients[2,1]
p = summary_age$coefficients[2,4]

RF_result <- ggplot(df, aes(x = Actual, y = Predict)) + 
  geom_point(size = 0.5, color = "#00A087FF") + 
  labs(x = "Actual Age", y = "Predicted Value")+
  stat_smooth(method = lm, level = 0.95, color = "#27408B") +
  theme(panel.background = element_rect(fill = "transparent", colour = NA))

print(RF_result)
ggsave(RF_result, filename = "RF_lm.pdf", width = 4, height = 4)
