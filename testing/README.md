
# Testing

There are a couple things we need to test in this project:
* Weekday/weekend split
* Groupby-mean accuracy
* Clustering usefulness

## Weekend/weekday split
This one takes a while. It has already been verified, but I have not made a script to run this yet. It makes use of the `wc -l` command to count the lines in each CSV file in the weekend/weekday split. The sum of weekend and weekday rows should be equal to the number of rows in the full dataset.

## Groupby-mean Accuracy
This test is mostly written in bash. For my ground truth, I'm using `grep -e` to pull each NMI's data from a file and `Pandas DataFrame` to calculate the mean for each column. If the output from this appraoch exceeds a threshold, it will be logged.

## Clustering usefulness
A simple script to run KMeans for different values of K and output the following statistics:
* Inter-cluster variance
* Intra-cluster variance