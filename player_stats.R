library(ggplot2)
library(ggthemes)

df_stats = read.csv("player_stats.csv")
df_skill_tiers = read.csv("player_ids_by_skill_tier.csv")
df = merge(df_stats, df_skill_tiers, by.x = "steam_id", by.y = "account_id")

ggplot(df, aes(x=accuracy_no_onos, fill=skill_tier)) + 
  labs(y = "Count", x = "Accuracy (no Onos)", title = "No Onos marine accuracy per skill tier") +
  scale_x_continuous(labels = scales::percent, limits = c(0, 0.5)) +
  scale_y_continuous(min = 0) +
  geom_histogram(fill = "white", colour = "black", breaks=seq(0, 0.5, 0.025)) + 
  facet_wrap(~skill_tier, scales = "free") # X scales are forced to be equal above