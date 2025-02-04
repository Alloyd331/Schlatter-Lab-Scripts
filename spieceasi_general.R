library(tidyverse)
library(SpiecEasi)

# Building the spieceasi network is a computationally expensive process, the 
# following is a script to run this process in a non-interactive HPC computing 
# environment. 

# importing and formatting ASV table =======================================
x <- readRDS("ASV_table.rds")
# This ASV table is the sole input for this step in the spieceasi process it 
# needs to be a numerical matrix with ASV/OTU identifiers as column names and 
# sample ids as row names. 

#building the network
set.seed(568)
netx <- spiec.easi(x1, method='mb', icov.select.params=list(rep.num=150))
saveRDS(netx, file="net_year.rds")
