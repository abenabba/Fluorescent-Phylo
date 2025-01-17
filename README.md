# Constructing a Phylogenetic Tree of All Beta Barrel Fluorescent Proteins
This guide explains how to construct a phylogenetic tree to visualize the relatedness of fluorescent protein sequences, which ultimetely is a parent library I mutagenize and use as an ML training set. The process involves preparing sequence data, creating an alignment, and generating a phylogenetic tree using tools like Clustal Omega, Jalview, and R Studio.

Before starting, make sure you have the following packages installed:

Jalview: For visualization and converting alignment files to tree formats.
Clustal Omega: For sequence alignment.
Python environment: For preparing the sequence data.
R Studio: For visualizing the phylogenetic tree.

Additionally, the following R libraries will be useful:

tidyverse
ggtree
dplyr

# Fluorescent-Phylo
Generating a Phylogenetic Tree of the Parental fluorescent Proteins synthesized in my gene library

**Step 1: Prepare the FASTA File**
Extract amino acid sequences and their names from your CSV file and save them in FASTA format. Use the following Python code:

```
import pandas as pd

# Read the CSV file
csv_file_path = 'FP_DB_full (2).csv'  # Replace with your CSV file path
data = pd.read_csv(csv_file_path)

# Create a function to write sequences to a FASTA file
def write_fasta_file(data, output_file):
    with open(output_file, 'w') as f:
        for index, row in data.iterrows():
            sequence_name = row['Accession']
            sequence = row['Sequence']
            f.write(f'>{sequence_name}\n{sequence}\n')

# Output FASTA file path
output_fasta_file = 'output.fasta'  # Replace with your desired output FASTA file path

# Write sequences to a FASTA file
write_fasta_file(data, output_fasta_file)
```
Note that the CSV file contains columns labeled Accession (sequence names) and Sequence (amino acid sequences), which is called in this code.

**Step 2: Align the Sequences**
- Place the generated FASTA file in your working directory.
- Run Clustal Omega to align the sequences:
- Select the correct sequence type (protein, DNA, RNA).
- Perform the alignment.

**Step 3: Visualize the Alignment and Export the Tree**
Use the Jalview option in Clustal Omega to visualize the alignment:

Copy the alignment URL from Clustal Omega.
Open Jalview: File -> Input Alignment -> From URL.
In the alignment window, go to Calculate -> Calculate Tree or PCA -> Neighbor Joining (I chose neighbor joining, which uses distance data between species to create the tree).
Save the tree in *Newick* format:

File -> Save As -> Newick Format.
Modify the Newick file:

Open the file in a text editor (e.g., Sublime Text).
Replace all semicolons (;) with underscores (_), except for the final semicolon.

**Step 4: Generate the Phylogenetic Tree in R Studio**
Place the modified .tree file in your R working directory.
Use the following R script to create and customize a circular phylogenetic tree:
```
library(dplyr)
library(tidyverse)
library(ggtree)

tree1 <- read.tree("fp tree.tree") # Newick format
tree1

tree_plot <- ggtree(tree1, layout = "circular", branch.length = "none")
tree_plot

# Add node points
tree_plot + geom_nodepoint()

# Add tip points
tree_plot + geom_tippoint()

# Label the tips
tree_plot + geom_tiplab(aes(x = branch))
```
**Example of tree generated**
![fp tree_linear](https://github.com/user-attachments/assets/7ec0a8f8-e882-44f5-8a5c-614096ef1124)

Version of tree where BFP variants are denoted
![phylotree_with_BFP_annotated](https://github.com/user-attachments/assets/51c7c8d7-f541-49dd-ab9b-c8f36c92141c)

