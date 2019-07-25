library(ggplot2)
library(dplyr)
library(scales)

df = read.csv("adagrad_sum_active.csv") %>% filter(adagrad_sum != 0) %>% filter(skill != 0)
df$offset = 25 / sqrt(df$adagrad_sum)
nrow(df)
df_sample = df %>% filter(offset < 1000)
nrow(df_sample)

# df_sample = df[sample(nrow(df), 5000), ]

median_offset = median(df$offset)
quantile_offset = quantile(df$offset, c(0.95))

ggplot(df_sample, aes(x=offset)) + 
  labs(y = "Count", x = "Skill offset", title = "Offset for skill tier assignments of active players (Played in 2019, >= 5h total, tail truncated)") +
  geom_histogram(fill="white", color="black", binwidth=10) +
  scale_x_continuous(breaks = seq(0, 1000, by = 100)) +
  # Median & 90th quantile offset line
  geom_vline(aes(xintercept = median_offset), color = "blue", linetype = "dashed", size = 1) +
  annotate("text", x = median_offset + 10, y = 800, label = "Median", hjust = 0, color = "blue") + 
  geom_vline(aes(xintercept = quantile_offset), color = "blue", linetype = "dashed", size = 1) +
  annotate("text", x = quantile_offset + 10, y = 800, label = "95th quantile", hjust = 0, color = "blue") 
