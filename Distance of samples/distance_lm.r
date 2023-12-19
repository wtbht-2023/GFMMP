
### The northernmost resident were selected to calculate Bray-Curtis distance and Pearson values to the other individuals
### the lm result
library(ggplot2)



distance_data <- read.delim("distance_info.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)

point_distance <- ggplot(distance_data, aes(x=real, y=pearson)) + geom_point(size=0.5, color = "#B1A56B") + stat_smooth(method=lm, level=0.95)
print(point_distance)
ggsave(point_distance,file=paste0("sample_distance_real_pearson.pdf"),width = 10,height = 8)



point_distance <- ggplot(distance_data, aes(x=real, y=bray)) + geom_point(size=0.5, color = "#D3A780") + stat_smooth(method=lm, level=0.95, color = "#CC0033")
print(point_distance)
ggsave(point_distance,file=paste0("sample_distance_real_bray.pdf"), width = 10,height = 8)

