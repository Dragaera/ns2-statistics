library(ggplot2)
library(dplyr)
library(scales)
library(viridis)

skill_interval_width = 500

df = read.csv("winrates/data/winrates.csv")
df = df %>% filter(winning_team != "", avg_player_count >= 16)
df$round_date = strptime(df$round_date, "%Y-%m-%d %H:%M:%S")

df$skill_bucket = cut(df$linear_avg_skill, breaks = seq(0, max(df$linear_avg_skill), skill_interval_width), dig.lab = 10)

df_summed = df %>%
  group_by(skill_bucket, winning_team) %>%
  summarize(
    win_count = n()
  ) %>%
  mutate(
    win_percentage = win_count / sum(win_count)
  ) %>%
  filter(!is.na(skill_bucket))


ggplot(df_summed, aes(x = skill_bucket, fill = winning_team, y = win_percentage)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = win_count), position = position_stack(vjust = 0.5)) +
  scale_y_continuous(breaks = seq(0, 1, 0.2), labels = scales::percent_format()) +
  labs(title = "Alien & marine win percentage by skill", subtitle = "TTO & TA, rounds with >= 16 players, since b327", x = "Average skill", y = "Win percentage") +
  theme_minimal()
