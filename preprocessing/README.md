# Preprocessing

The main preprocessing in this project is splitting up the dataset into weekend/weekday. The reason it has it's own folder is because the analysis in this project around dates could also extend to seasonal energy usage. However, in this project, we are only sticking to weekday/weekend.

In this folder, I have two different implementations to split the file up by weekend/weekday:

1) A shell script
2) A C program

If it were possible to split up the dataset using the shell script, I certainly would. However, it took 24 hours to process 8GB out of the 40GB on a GCP `n1-standard-2` (dual core, 8GB - however only 1 thread was used). At that rate, it would have taken 5 days!

So, I decided to implement it in C to see if that sped it up. Fortunately, it took 12 minutes on the same `n1-standard-2` machine! In this case, the development time was definitely worthwhile.

There is potential for multi-threading in both implementations, but that's not a concern at this point as long as the output is correct.