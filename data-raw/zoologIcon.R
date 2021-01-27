library(ggplot2)

# Helper theme for ggplot icon
theme_icon <- function () {
  theme_void() +
    theme(
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA),
      legend.background = element_rect(fill = "transparent", colour = NA),
      legend.box.background = element_rect(fill = "transparent", colour = NA)
    )
}

library(png)
library(grid)
img <- readPNG("~/Desktop/zoolog9.png")
g <- rasterGrob(img, interpolate=TRUE)

library(hexSticker)
p <- ggplot(iris, aes(Species, Sepal.Length)) +
  annotation_custom(g, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf) +
  theme_icon()
p.sticker <- sticker(
  p, package=" ", p_size = 3, h_size = 0.5,
  s_x = 0.99, s_y = 0.99, s_width = 1.6, s_height = 2.2,
  h_color = "#ffffe9", h_fill = "#c8c846",
  filename = "inst/icon3b.png", dpi = 600
)
