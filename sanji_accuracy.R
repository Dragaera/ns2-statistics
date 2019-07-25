library(ggplot2)
library(ggrepel)
library(reshape)
library(dplyr)
library(scales)

df = read.csv("sanji_marine_acc.csv")

ggplot(df, aes(x=accuracy_no_onos)) + 
  labs(y = "Count", x = "Accuracy (no Onos)", title = "No Onos marine accuracy of sanji players") +
  scale_x_continuous(labels = scales::percent) +
  geom_histogram(fill="white", color="black", breaks=seq(0, 0.5, 0.025))