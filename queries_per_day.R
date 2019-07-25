library(ggplot2)
library(ggthemes)

df = read.csv("queries_per_day.csv")
df$timestamp = as.POSIXct(strptime(df$timestamp, "%Y-%m-%d %H:%M:%S"))

ggplot(data = df, aes(x=timestamp, y=count)) + 
  labs(y = "Updates", x = "Timestamp", title = "Hive updates over time") + 
  scale_x_datetime(date_breaks = "6 hours") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  geom_line()
