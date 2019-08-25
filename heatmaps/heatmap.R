library(ggplot2)
library(dplyr)
library(scales)
library(viridis)
library(png)
library(ggpubr)

# magic number from NS2 source
extents_scale_factor = 0.239246666431427
# length / width of minimap image
minimap_size = 1024
minimap_size.half = minimap_size / 2
minimap.extents = c(-minimap_size.half, minimap_size.half)
# 
# # ns2_tram
# origin.x = -16.647284
# origin.z = 51.335014
# scale.x = scale.z = 350

# # ns2_veil
# origin.x = -14.572644
# origin.z = -87.426842
# scale.x = 424.560120
# scale.z = 424.560150

# # ns2_summit
# origin.x = 26.666611
# origin.z = 59.330097
# scale.x = 449.228271
# scale.z = 449.230011

# # ns2_unearthed
# origin.x = 144.546127
# origin.z = 83.407074
# scale.x = 385.000031
# scale.z = 384.999969

# ns2_biodome
origin.x = 47.552223
origin.z = -5.500417
scale.x = 475.049652
scale.z = 475.049988


map = 'biodome'

halfext = max(scale.x * extents_scale_factor, scale.z * extents_scale_factor)
scale_factor = minimap_size.half / halfext

df = read.csv(paste("heatmaps/data/", map, ".csv", sep=""))

img = png::readPNG(paste("heatmaps/resources/ns2_", map, ".png", sep=""))

# Apply minimap-to-world-offset
df$x = df$x - origin.x
df$z = df$z - origin.z

# Scale from world to minimap coordinates
df$x = df$x * scale_factor
df$z = df$z * scale_factor

# Rotate 90deg clockwise & flip vertically to fix accommodate different alignment of world and minimap axes
df$x_rot = df$z
df$z_rot = df$x # -(- df$x)
df$x = df$x_rot
df$z = df$z_rot

# Get rid of anything outside of the area covered by the minimap. Likely the ready room, hidden rooms etc.
df = df %>% filter(abs(x) <= minimap_size / 2, abs(y) <= minimap_size / 2)
df$sort = abs(df$x) + abs(df$z)
df = df %>% arrange(sort)

team_filter = 'marines'
df_team = df %>% filter(team == team_filter)
df_sample = df_team[sample(nrow(df_team), 13000), ]

ggplot(df_sample, aes(x=x, y=z)) +
  coord_fixed(xlim = minimap.extents, ylim = minimap.extents, expand = FALSE) + # 1:1 ratio between axes, no additional space around given limits
  background_image(img) +
  geom_point(size=0.1, aes(colour=team, shape=team)) +
  theme_void() +
  theme(legend.position = "none")


ggplot(df_team, aes(x=x, y=z)) +
  labs(title = paste("Kills on ", map, ": ", paste("TTO", ">= 2019-03-01", team_filter, sep = ", "), sep = "")) +
  xlim(-1000, 1000) + ylim(-1000, 1000) +
  coord_fixed(xlim = minimap.extents, ylim = minimap.extents, expand = FALSE) + # 1:1 ratio between axes, no additional space around given limits
  background_image(img) +
  # stat_density2d(aes(fill = stat(density), alpha = stat(density)), geom = "tile", contour = FALSE, h = c(150, 150)) +
  stat_density2d(aes(fill = stat(level), alpha = stat(level)), geom = "polygon", bins = 16, n = 200) +
  scale_fill_viridis() +
  scale_alpha(range = c(0.0, 0.5), guide = FALSE) + 
  geom_point(df_sample, mapping = aes(x=x, y=z), alpha = 0.05, size = 0.1, colour = "cyan") +
  theme_void()


