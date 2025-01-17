
library(dplyr)
###
library(tidyverse)
library(ggtree)
tree1<-read.tree("fp tree.tree") # newick format
tree1

tree_plot<-ggtree(tree1, layout = "circular", branch.length = "none")
tree_plot

# add node points
tree_plot + geom_nodepoint()

# add tip points
tree_plot + geom_tippoint()

# Label the tips
tree_plot + geom_tiplab(aes(x=branch))


tree_plot <- tree_plot +
  geom_tree(color = "lightgrey") +  # Set the color of the entire tree to blue
  theme_tree2() +  # Apply ggtree's theme
  theme(panel.background = element_rect(fill = "black"))  # Set background color to black

# Display the tree with the updated color and black background
tree_plot

#####

# Read the CSV file containing sequences and emission wavelengths
fp_data <- read.csv("FP_DB_full (2).csv")  # Replace with your CSV file path

# Assuming 'tree_plot' is your ggtree object representing the phylogenetic tree

# Extract the labels from the tree
tree_labels <- as.data.frame(tree_plot$data)$label

# Filter the data from the CSV file based on matching Accession names and non-missing emission values
matched_data <- fp_data %>%
  filter(!is.na(states.0.ex_max) & !is.na(Accession) & Accession %in% tree_labels) %>%
  select(Accession, states.0.ex_max)

# Define emission range boundaries for different colors of fluorescent proteins
emission_bounds <- c(400, 450, 490, 550, 580, 600, 650)

# Create a color palette for emissions (adjust as needed)
color_palette <- colorRampPalette(c("lightslateblue", "skyblue1", "seagreen1", "goldenrod1", "orange", "maroon"))(100)

# Define a function to assign colors based on emission wavelengths and specific bounds
assign_color <- function(emission_value) {
  color_index <- findInterval(emission_value, emission_bounds)
  color_palette[color_index]
}

# Merge matched data back to the tree labels
tree_labels_with_colors <- merge(
  x = as.data.frame(tree_plot$data),
  y = matched_data,
  by.x = "label",
  by.y = "Accession",
  all.x = TRUE
)

# Assign colors to branches based on emission wavelengths
valid_indices <- !is.na(tree_labels_with_colors$states.0.ex_max)
tree_labels_with_colors$color <- ifelse(valid_indices, assign_color(tree_labels_with_colors$states.0.ex_max), "black")

# Update tree plot with colored branches
tree_plot <- tree_plot +
  geom_tree(aes(color = color), data = tree_labels_with_colors)

# Update tree plot with colored branches and black background
tree_plot <- tree_plot +
  geom_tree(aes(color = color), data = tree_labels_with_colors) +
  theme_tree2() +  # Apply ggtree's theme
  theme(panel.background = element_rect(fill = "black"))  # Set background color to black

# Display the tree with colored branches and a black background
tree_plot


