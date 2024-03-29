# EFSCF
“Enhanced Robust Spatial Feature Selection and Correlation Filter Learning for UAV Tracking”, Neural Networks,2022. 

https://www.sciencedirect.com/science/article/pii/S0893608023000035

EFSCF is a tracker based on correlation filter for UAV tracking which can run at ~18fps on a single CPU. Note that due to different configuration environment, some algorithms may be inconsistent with the original results of the their papers. For fair comparison, all trackers run on the same platform with ubuntu16.04,matlab2017b,matconvnet-1.0-beta25,opencv2.4.13,GPU NVIDIA-1080.

# Download

[models](https://pan.baidu.com/s/15AsfSXGOmUH8QhbZBuYZtg) password: nj4b

[Google Drive](https://drive.google.com/drive/folders/1GWu_zEuVf2Q_fRV0vIDhyvKqftkeKInM)

# Results

We have tested our algorithm on UAV123，UAV20L, UAVDT, Visdrone2019, OTB2015, OTB2013 datasets and have achieved good performance compared to other algorithms.

2020-06

```bash
| OTB2013 | OURS | LADCF | STRCF | ECO_HC | ARCF |  BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 693  | 675   | 687   | 667    | 642  |  657  | 618   | 558  | 580  | 514  |
| P*1000  | 892  | 864   | 892   | 889    | 850  | 861  | 823   | 748  | 785  | 740  |
```

```bash
| OTB100  | OURS | LADCF | STRCF | ECO_HC | ARCF |  BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- |  ---- | ----- | ---- | ---- | ---- |
| S*1000  | 675  | 664   | 657   | 644    | 617  |  621  | 591   | 518  | 555  | 477  |
| P*1000  | 875  | 864   | 865   | 858    | 818  |  824  | 776   | 689  | 754  | 696  |
```

```bash
| UAV_123 | OURS | LADCF | STRCF | ECO_HC | ARCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- |  ---- | ----- | ---- | ---- | ---- |
| S*1000  | 509  | 494   | 478   | 505    | 470  |  458  | 459   | 410  | 395  | 331  |
| P*1000  | 712  | 702   | 678   | 724    | 674  |  656  | 665   | 590  | 576  | 523  |
```

```bash
| UAV20L | OURS | LADCF | STRCF | ECO_HC | ARCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------ | ---- | ----- | ----- | ------ | ---- |  ---- | ----- | ---- | ---- | ---- |
| S*1000 | 452  | 445   | 416   | 419    | 396  |  397  | 343   | 270  | 317  | 196  |
| P*1000 | 604  | 593   | 560   | 547    | 559  |  554  | 507   | 459  | 457  | 311  |
```

```bash
| UAVDT   | OURS | LADCF | STRCF | ECO_HC | ARCF |  BACF | SRDCF | DSST | SAMF | KCF  |
| ------  | ---- | ----- | ----- | ------ | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 478  | 431   | 418   | 431    | 470  |  439  | 428   | 405  | 336  | 293  |
| P*1000  | 750  | 662   | 638   | 718    | 740  |  704  | 690   | 702  | 591  | 575  |
```

```bash
| VisDrone19 | OURS | LADCF | STRCF | ECO_HC | ARCF |  BACF | DSST | SAMF | KCF  | OURS |
| ---------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ---- | ---- | ---- |
| S*1000     | 544  | 484   | 537   | 561    | 546  |  510  | 497  | 459  | 392  | 539  |
| P*1000     | 749  | 674   | 742   | 753    | 735  |  699  | 675  | 648  | 591  | 743  |
```
# Success and Precision Plots
## UAV123
![image](./results/UAV123/quality_plot_error_OPE_threshold.png)
![image](./results/UAV123/quality_plot_overlap_OPE_AUC.png)

## UAV20L
![image](./results/UAV20L/quality_plot_error_OPE_threshold.png)
![image](./results/UAV20L/quality_plot_overlap_OPE_AUC.png)

## UAVDT
![image](./results/UAVDT/quality_plot_error_OPE_threshold.png)
![image](./results/UAVDT/quality_plot_overlap_OPE_AUC.png)

## VisDrone2019-SOT-Train
![image](./results/VisDrone/quality_plot_error_OPE_threshold.png)
![image](./results/VisDrone/quality_plot_overlap_OPE_AUC.png)

# Reference

Wen J, Chu H, Lai Z, et al. Enhanced robust spatial feature selection and correlation filter learning for UAV tracking[J]. Neural Networks, 2023.

# Acknowledgements
We thank the contribution of ARCF,STRCF,LADCF, GFSDCF,and ECO. Some of the parameter settings and functions are borrowed from STRCF (https://github.com/lifeng9472/STRCF) ,LADCF (https://github.com/XU-TIANYANG/LADCF).
