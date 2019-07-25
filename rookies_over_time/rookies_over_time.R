library(ggplot2)
library(dplyr)
library(scales)

df_apheriox = read.csv("rookies_over_time/rookies_over_time_apheriox.csv")
df_apheriox$server = 'Apheriox'

df_diamondgamers = read.csv("rookies_over_time/rookies_over_time_diamondgamers.csv")
df_diamondgamers$server = 'Diamondgamers'

df_hashtagawesome = read.csv("rookies_over_time/rookies_over_time_hashtagawesome.csv")
df_hashtagawesome$server = 'Hashtageawesome'

df_tto = read.csv("rookies_over_time/rookies_over_time_tto.csv")
df_tto$server = 'The Thirsty Onos'

df = rbind(df_apheriox, df_diamondgamers, df_hashtagawesome, df_tto)

# as.Date(as.character()) as cut() returns factors, but for aggregation purposes in ggplot we need Date
df$timestamp = as.Date(as.character(cut(as.Date(strptime(df$timestamp, "%Y-%m-%d %H:%M:%S")), "month")))
df_per_day = df %>% 
  group_by(timestamp, server) %>%
  summarise(
    rookie_count_sum = sum(rookie_count), 
    nonrookie_count_sum = sum(nonrookie_count),
    rookie_percentage = rookie_count_sum / (rookie_count_sum + nonrookie_count_sum),
    n = n()
  )


# ggplot(data = df, aes(x = timestamp)) +
#   labs(y = "Count", x = "Date", title = "Rookie players over time (TTO)") + 
#   scale_x_date(date_breaks = "1 month", date_minor_breaks = "4 week") +
#   theme(axis.text.x=element_text(angle=60, hjust=1)) +
#   geom_bar(aes(weight = player_count, fill = factor(is_rookie)))

ggplot(data = df_per_day, aes(x = timestamp, y = rookie_percentage, group = server, color = server)) +
  labs(y = "Rookie player percentage", x = "Date", title = "Rookie players over time") +
  scale_x_date(date_breaks = "2 month", date_minor_breaks = "1 month") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  geom_line(aes(linetype = server)) +
  geom_point(aes(shape = server)) 
