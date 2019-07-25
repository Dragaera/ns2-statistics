library(ggplot2)
library(ggrepel)
library(reshape)
library(dplyr)
library(scales)

df = read.csv("skill_history_tiered.csv")
df$timestamp = as.Date(strptime(df$timestamp, "%Y-%m-%d %H:%M:%S"))

ggplot(data = df, aes(x=timestamp, y=average_skill, color=skill_tier)) + 
  labs(y = "Average skill", x = "Date", title = "Development of average skill over time") + 
  scale_x_date(date_breaks = "3 months", date_minor_breaks = "1 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

ggplot(data = df, aes(x=timestamp, y=count, color=skill_tier)) + 
  labs(y = "Count", x = "Date", title = "Skill tier distribution over time") + 
  scale_x_date(date_breaks = "3 months", date_minor_breaks = "1 month") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

skill_tier_colours = c("#54b28a", "#b28099", "#97806c", "#93adb8", "#b9a579", "#86b3ce", "#8374bf", "#b5711e")
df_skill_tiers = read.csv("skill_tier_distribution_active.csv")
df_skill_tiers$count_rel = df_skill_tiers$count / sum(df_skill_tiers$count) * 100
df_skill_tiers = arrange(df_skill_tiers, desc(skill_tier))

ggplot(data = df_skill_tiers, aes(x = "", y = count_rel, fill = skill_tier)) +
  labs(x = "", y = "", title = "Skill tier distribution of players active at least three times in last 30 days", fill = "") + 
  geom_bar(width = 1, stat = "identity", color = "white") + 
  coord_polar("y", start = 0) +
  geom_label_repel(aes(y = cumsum(count_rel) - 0.5 * count_rel, label = paste(skill_tier, percent(count_rel / 100))), color = "white") +
  scale_fill_manual(values = skill_tier_colours) +
  theme(legend.position = "none")
