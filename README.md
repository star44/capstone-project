# IFB399 Capstone Project

Our project is centred around clustering EQL energy usage data. The basic approach is to calculate an averaged profile for each user across various significant time periods. Given that the current dataset is 40GB, an out-of-memory solution is necessary. Since the number of users with Smart Metering devices is also expected to rise, scalable solutions will be preferable. With these facts in mind, we agreed on the following artefacts to be completed by the end of the semester:

## Artefacts
* Clustering of averaged user profiles. Method not defined. This includes testing.
* Jupyter Notebook
* Design Report
* Scalability Analysis


## Stretch Goals
In order to score a higher grade in this project, we need to accomplish some stretch goals. These are goals that will help the client, and ones we need to agree on with the client. However, they  aren't part of this project and there is no expectation of completing them. We have not yet agreed on this with the client, but we are considering proposing the following stretch goals:

* CUDA implementation - This began as a weekend project, but if we manually implement string parsing on a GPU. At this current point in time, on my GTX1060 I can allocate the memory for, and parse a 2GB chunk in approximately 5 seconds. This does not include normalising and writing to file, but if done efficiently these steps are not expected to take very long. Unfortunately, my parsing of strings to floats has some minor errors which I am currently trying to find the reason for.
* DaskML implementation - Using an experimental library, we can connect multiple computers to read from the same dataset.
* Cloud Based Solution - We could use a cloud provider such as GCP or AWS. However, it will most likely be an expensive solution.