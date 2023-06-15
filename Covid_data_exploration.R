#Load the data from the csv file to a data frame
df <- read.csv('C:/Users/User/Desktop/SQL/Alex/My own version/June2023_CovidData.csv')

#Convert the date column into a time stamp
df$date <- as.POSIXct(df$date)

# Compute summary statistics
summary_df <- summary(df)
print(summary_df)

#Compute the correlation matrix
# Subset the data frame to include only numeric columns and replace NAs with 0
numeric_df <- df[, sapply(df, is.numeric)]
numeric_df[is.na(numeric_df)] <- 0

# Compute the correlation matrix
corr <- cor(numeric_df)

# Install missing packages
#install.packages("gplots")
#install.packages("RColorBrewer")

# Load required packages
library(gplots)
library(RColorBrewer)

library(gplots)
library(RColorBrewer)
#options(repr.plot.width=11, repr.plot.height=9)

#Generate a custom diverging color palette
palette <- colorRampPalette(brewer.pal(11, "RdBu"))(256)

# Specify the height of each row in lmat
lhei <- c(2, 2, 5, 10)

# Plot the heatmap with the correct lhei argument
heatmap.2(corr, trace = "none", key = TRUE, symm = TRUE, density.info = "none",
          col = palette, scale = "none", margin = c(10, 10), lmat = rbind(c(5), c(4, 3), c(2), c(1)),
          lhei = lhei, main = "Correlation Matrix", xlab = "", ylab = "",
          key.title = "Correlation", key.xlab = "Correlation Coefficient",
          key.ylab = "", key.title.adj = 0.5, key.xlab.adj = 0.5)
### Need to resize rownames and height of each row

