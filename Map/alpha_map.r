###alpha diversity result was ploted in map###


library(geojsonsf)
library(sf)
library(ggplot2)
library(RColorBrewer)
library(openxlsx)

API_pre = "http://xzqh.mca.gov.cn/data/"

China = st_read(dsn = paste0(API_pre, "quanguo.json"), 
                stringsAsFactors=FALSE) 
st_crs(China) = 4326


China_line = st_read(dsn = paste0(API_pre, "quanguo_Line.geojson"), 
                     stringsAsFactors=FALSE) 
st_crs(China_line) = 4326

gjx <- China_line[China_line$QUHUADAIMA == "guojiexian",]



province_mid <- read.xlsx("province_mid.xlsx", sheet = 1)

province_use_name = c("HeiLongjiang","LiaoNing","ShanDong","JiangSu","ZheJiang","ShangHai",
                      "BeiJing","ShanXi","HeNan","HuBei",
                      "HuNan","ChongQing","GuiZhou","YunNan","GuangXi")

province_use_chinese <- c("黑龙江","辽宁","山东","江苏","浙江","上海","北京",
                          "陕西","河南","湖北","湖南","重庆","贵州","云南","广西")

province_use <- data.frame(province_use_name, province_use_chinese)

province_mid_use <- merge(province_mid, province_use, by.x = "省市", by.y = "province_use_chinese")



zhuose_data <- read.xlsx("your_data.xlsx", sheet = 1)


province_name <- c("XinJiang", "XiZang", "QingHai", "GanSu", "NingXia", "NeiMenggu", "ShanXi1",
                   "HeiLongjiang", "JiLin", "YunNan", "GuiZhou", "GuangXi", "ChongQing",
                   "JiangXi", "HaiNan", "SiChuan", "ShanXi", "HeNan", "HeBei", "AnHui",
                   "FuJian", "HuNan", "HuBei", "LiaoNing", "TianJin", "ZheJiang", 
                   "ShangHai", "BeiJing", "ShanDong", "JiangSu", "GuangDong")
mydata <- data.frame(zhuose_data, province_name)
mydata <- mydata[,-2]

alpha_province <- read.delim("alpha_province.txt", sep = "\t", header = T, check.names = F, stringsAsFactors = F)


alpha_index1 <- data.frame(log2(alpha_province[,1]))
alpha_index1$province <- rownames(alpha_province)
colnames(alpha_index1)[1] <- "alpha_index"
mydata_use <- merge(mydata, alpha_index1, by.x = "province_name", by.y = "province")
mydata_use$QUHUADAIMA <- as.character(mydata_use$QUHUADAIMA)
mydata_use$QUHUADAIMA[2] <- "500000"
alpha_index_name <- colnames(alpha_province)[1]

CHINA_alpha_index1 <- dplyr::left_join(China, mydata_use,by= "QUHUADAIMA")
middle <- min(alpha_index1$alpha_index)+(max(alpha_index1$alpha_index) - min(alpha_index1$alpha_index))/2
p <- ggplot()+

  geom_sf(data = CHINA_alpha_index1,aes(fill = alpha_index)) +
  
  scale_fill_gradient2(low = "DarkGreen", high = "Brown", mid = "Gold", midpoint = middle, na.value = "WhiteSmoke") +
  geom_sf(data = gjx)+
  geom_text(data = province_mid_use,aes(x=dili_Jd,y=dili_Wd,label=province_use_name),
            position = "identity",size=3,check_overlap = TRUE) +
  theme(
    plot.title = element_text(color="red", size=16, face="bold",vjust = 0.1,hjust = 0.5),
    plot.subtitle = element_text(size=10,vjust = 0.1,hjust = 0.5),
    legend.title=element_blank(),
    legend.position = c(0.2,0.2),
    panel.grid=element_blank(),
    panel.background=element_blank(),
    axis.text=element_blank(),
    axis.ticks=element_blank(),
    axis.title=element_blank()
  )
p
ggsave(p, file = paste0("differ_alpha_index.pdf"), width = 8, height = 8)



