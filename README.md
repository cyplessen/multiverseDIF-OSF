# Differential Item Functioning By Language on the new PROMIS® Physical Functioning Items 2.0 for Adults

This repository contains all code and data to reproduce the analyses for the paper: *Differential Item Functioning By Language on the New PROMIS® Physical Functioning Items 2.0 for Adults*

We conducted a multiverse DIF analyses that contains 272 plausible DIF analyses within the `lordif` framework. We also provide a companion *R* package to facilitating similar sensitivity analyses: [lordifMultiverse](https://github.com/cyplessen/lordifMultiverse).


## Structure and files:

- `ao1_1_...` contains exploratory data analysis.
- `ao1_2_...` contains code to run multiverse DIF analysis. 
- `ao1_3_...` contains code to inspect DIF at the item and test level.
- `ao1_4_...` contains all information on individual DIF analysis steps within `lordif`.  
- `/data` contains the data from the actual publication and pertubated item parameters as outlined by [Maxwell Armand Mansolf](https://osf.io/vq9j7/).   
- `/R` and `/man` contain all relevant functions used to conduct all analyses. 
