library(ggplot2)
library(dplyr)
library(scales)
library(viridis)

df = read.csv("round_length/data/round_length.csv")
df = df %>% filter(avg_skill >= 0)

df$round_length = df$round_length / 60
df$skill_bucket = df$avg_skill - (df$avg_skill %% 100)

df_summed = df %>%
  group_by(skill_bucket, server_name) %>% 
  summarize(mean_length = mean(round_length), n = n(), sd = sd(round_length))

df_filtered = df %>% filter(max_players >= 10, player_count >= 20)
#%>% filter(avg_skill <= 1500)

median_length = median(df_filtered$round_length)
qt_5_length = quantile(df_filtered$round_length, c(0.05))
qt_95_length = quantile(df_filtered$round_length, c(0.95))
qt_99_length = quantile(df_filtered$round_length, c(0.99))

ggplot(df_filtered, aes(x=round_length)) + 
  labs(y = "Count", x = "Round length [min] (Rounds with >= 10v10)", title = "Round length") +
  geom_histogram(fill="white", color="black", binwidth=5) +
  scale_x_continuous(breaks = seq(0, max(df$round_length), 15), minor_breaks = seq(0, max(df$round_length), 5)) +
  
  # Median
  geom_vline(aes(xintercept = median_length), color = "blue", linetype = "dashed", size = 1) +
  annotate("text", x = median_length + 10, y = 6500, label = "50%", hjust = 1.5, color = "blue") + 
  # 5th quantile
  geom_vline(aes(xintercept = qt_5_length), color = "green", linetype = "dashed", size = 1) +
  annotate("text", x = qt_5_length + 10, y = 6500, label = "5%", hjust = 1.5, color = "green") + 
  # 95th quantile
  geom_vline(aes(xintercept = qt_95_length), color = "violet", linetype = "dashed", size = 1) +
  annotate("text", x = qt_95_length + 10, y = 6500, label = "95%", hjust = 1.5, color = "violet") + 
  # 99th quantile
  geom_vline(aes(xintercept = qt_99_length), color = "brown", linetype = "dashed", size = 1) +
  annotate("text", x = qt_99_length + 10, y = 6500, label = "99%", hjust = 1.5, color = "brown") +
  
  theme_minimal()

ggplot(df_summed, aes(x=skill_bucket, y=mean_length, color=server_name)) + 
  labs(y = "Average round length", x = "Average skill", title = "Round time vs skill") +
  geom_point(aes(shape=server_name))# +
  #geom_errorbar(aes(ymin = mean_length - sd, ymax = mean_length + sd), width=30)
