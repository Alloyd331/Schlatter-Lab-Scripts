library(tidyverse)
library(ALDEx2)

# An R script for automating ALDEx2 analysis for microbiome data for use in a 
# non-interactive HPC computing system. The script takes as inputs an ASV/OTU
# table, a metadata table, and a taxonomy table. This script will automatically 
# take each variable column from the metadata table, and apply the appropriate 
# aldex2 test for each variable (wilcoxon/welches for variables with two 
# possibilities, kw/glm for variables three or more possibilities). For each 
# variable tested, the function will export a 

#importing files for analysis=======================

# Formatting guide for input files: 
# ASV table (x) must be numeric, and have the sample IDs as column names. ASV IDs 
# must be rownames. Metadata (y) must be a dataframe, with variable names as 
# column names and sample IDs as rownames. Taxonomy table (tax) must be a data
# frame with ASV identifiers present as a column with the column name "id", 
# followed by the taxonomy of the ASV with each taxonomic level represented as 
# a seperate column. To avoid formatting errors caused by import parsing, it is
# recommended to use .rds files as the imputs, however .csv or .txt files can 
# be used as well with appropriate modifications to the below code (provided the
# final file fed into the function is the correct format).

x <- readRDS("ASV_Table.rds")
y <- readRDS("metadata.rds") %>% as.data.frame()
tax <- readRDS("Tax_table.rds") %>% as.data.frame()
seed_no <- 555

#ALDEx2 function ==========================
ALv <- function(x,y,tax,seed_no,file_head){
  set.seed(seed_no)
  for(i in 1:ncol(x)){
    x <- x[, names(x) %in% rownames(y)]
  }
  for(j in 1:nrow(y)){
    y <- y[ rownames(y) %in% colnames(x),]
  }
  for (i in 1:ncol(x)){
    x <- x[, order(match(colnames(x), rownames(y))) ]
  }
  for (i in 1:ncol(y)) {
    if (n_distinct(y[,i]) == 2) {
      alx <- aldex(x, y[,i], test = "t", effect = T, verbose = T, 
                   mc.samples = 1000)
      alx <- alx %>% rownames_to_column( var = "id")
      alx1 <- left_join(alx, tax)
      f1 <- paste(file_head, colnames(y)[i], "t", sep="_")
      file_name <- paste(f1, ".csv", sep = "")
      write.csv(alx1, file = file_name, row.names = T, col.names = T)
    }
    else if (n_distinct(y[,i]) > 2){
      alx <- aldex(x, y[,i], test = "kw", effect = T, verbose = T, 
                   mc.samples = 1000)
      alx <- alx %>% rownames_to_column( var = "id")
      alx1 <- left_join(alx, tax)
      f1 <- paste(file_head, colnames(y)[i], "kw", sep="_")
      file_name <- paste(f1, ".csv", sep = "")
      write.csv(alx1, file = file_name, row.names = T, col.names = T)
    }
    else if (n_distinct(y[,i]) < 2){
      print("Error: parameter vector must contain 2 or more variables")
    }
  }
}

ALv(x,y,tax,seed_no)

