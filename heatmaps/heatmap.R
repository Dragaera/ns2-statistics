library(ggplot2)
library(dplyr)
library(scales)
library(RColorBrewer)
library(png)
library(ggpubr)


df = read.csv("heatmaps/heatmap.csv")

# ns2_tram
origin.x = -16.647284
origin.z = 51.335014
# Scale is seemingly *twice* the maximum extent in the x/z directions.
scale = 335
scale = 350 # according to NS2+

img <- png::readPNG("heatmaps/ns2_tram_flipped.png")

# minimap-to-world-offset
df$x = df$x - origin.x
df$z = df$z - origin.z

# Normalize to [-1, 1]
df$x = df$x / (scale / 2)
df$z = df$z / (scale / 2)

# And get rid of unsavoury values (ready-room, hidden rooms etc)
df = df %>% filter(abs(x) < 1, abs(z) < 1)

# Rotate 90deg clockwise, then flip vertically
df$x_rot = df$z
df$z_rot = df$x # -(-df$x)
df$x = df$x_rot
df$z = df$z_rot

df_sample = df[sample(nrow(df), 50000), ]

ggplot(df_sample, aes(x=x, y=z)) +
  coord_fixed(xlim = c(-0.5, 0.5), ylim = c(-0.5, 0.5), expand = FALSE) + # 1:1 ratio between axes, no additional space around given limits
  background_image(img) +
  geom_point(size=0.1)

ggplot(df, aes(x=x, y=z)) +
  coord_fixed(xlim = c(-0.5, 0.5), ylim = c(-0.5, 0.5), expand = FALSE) + # 1:1 ratio between axes
  background_image(img) +
  stat_density2d(aes(fill = ..level.., alpha = ..level..), geom = "polygon", bins = 16, size = 0.01) +
  scale_fill_distiller(palette = 'YlOrRd', direction=1) +
  scale_alpha(range = c(0.0, 0.5), guide = FALSE) + 
  # geom_point(df_sample, mapping = aes(x=x, y=z), alpha = 0.05, size = 0.1, colour = "black") +
  theme_void() +
  theme(legend.position = "none")


