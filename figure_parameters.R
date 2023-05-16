#The purpose of this script is to include functions/codes for common parameters
#that outputs useful figures, that are well configured, so we minimized the amount of time
#playing around with resizing and illustrator problems
#this is for small TSNE plots. For large TSNE/UMAP plots, we would format using axis themes
showCols <- function(cl=colors(), bg = "grey",
                     cex = 0.75, rot = 30) {
  m <- ceiling(sqrt(n <-length(cl)))
  length(cl) <- m*m; cm <- matrix(cl, m)
  require("grid")
  grid.newpage(); vp <- viewport(w = .92, h = .92)
  grid.rect(gp=gpar(fill=bg))
  grid.text(cm, x = col(cm)/m, y = rev(row(cm))/m, rot = rot,
            vp=vp, gp=gpar(cex = cex, col = cm))
}

cbPalette <- c("gray87", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

#showCols(cl = cbPalette, cex = 2)

require(ggplot2)

UMAP_theme <- theme_bw()+theme(axis.text.y = element_blank(), 
                               axis.text.x = element_blank(), 
                               axis.ticks.x= element_blank(),
                               axis.ticks.y= element_blank(),
                               axis.title.x= element_blank(),
                               axis.title.y= element_blank(),
                               strip.text.x = element_text(size = 8),
                               panel.grid.major = element_blank(),
                               panel.grid.minor = element_blank(),
                               panel.border = element_blank(),
                               panel.background = element_rect(colour = "black", fill = NA,size=1),
                               legend.position = "none",
                               plot.title = element_text(hjust = 0.5, size = 8))

remove_grid = theme_bw() + theme( panel.grid.major = element_blank(),
                               panel.grid.minor = element_blank())

Axis_themes <- theme(plot.title = element_text(size = 8),
                     axis.title = element_text(size = 8), 
                     axis.text = element_text(size = 6),
                     axis.text.x = element_text(size = 6),
                     legend.text = element_text(size =6),
                     legend.title = element_text(size = 8),
                     strip.text.x = element_text(size = 8))

No_axis_labels <- theme(axis.text.x=element_blank(),
                        axis.ticks.x=element_blank(),
                        axis.text.y=element_blank(),
                        axis.ticks.y=element_blank())

No_legend <- theme(legend.position = "none")
#theme(plot.margin = unit(c(0, 0, 0, 0), "in")

#for sizing, letter is 8.5 x 11 inch. so really we can work within 8x10 parameter
#288 pts is about 4 inches. 72 pt/inch

#primarily use ggsave to save our figures into different file format. need plot_list/cowplot to do last_plot() before
#we can actually push the figures into the devices.

#There are a lot of font inconsistency. From here on out, ?just use arial font.
#However, in saving for EPS file, we need to specify Family = "ArialMT" in order
#to make sure that the font turns out correct. The default font output for eps
#is Helvetica. But for pdf, arial will work. ggplot already plots automatically
#in Arial

#for geom_point to actually get smaller points, we'd have to use stroke = 0 and pch = 16 to get the size of the display to be much smaller
#I acutlaly think Seurat TSNE plot and in general alreayd took that into account. they alreayd use a lower pch.
