- ur paper is under review in  IEEE Transactions on Circuits and Systems for Video Technology (TCSVT) 

- EFSCF is a tracker based on correlation filter for UAV tracking which can run at ~18fps on a single CPU. Our algorithm will open in  2020. Note that due to different configuration environment, some algorithms may be inconsistent with the original results of the papers. For fair comparison, all  trackers are retested on the same platform with ubuntu16.04,matlab2017b,matconvnet-1.0-beta25,opencv2.4.13,GPU:NVIDIA-1080.

# Benchmark results

We have tested our algorithm on UAV123，UAV20L, UAVDT，Visdrone2019, OTB2015,OTB2013 datasets and have achieved good performance compared to other algorithms.

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
![image](https://github.com/HonglinChu/EFSCF/blob/master/results/UAV123/quality_plot_error_OPE_threshold.png)
![image](https://github.com/HonglinChu/EFSCF/blob/master/results/UAV123/quality_plot_overlap_OPE_AUC.png)

## UAV20L
![image](https://github.com/HonglinChu/EFSCF/blob/master/results/UAV20L/quality_plot_error_OPE_threshold.png)
![image](https://github.com/HonglinChu/EFSCF/blob/master/results/UAV20L/quality_plot_overlap_OPE_AUC.png)

## UAVDT
![image](https://github.com/HonglinChu/EFSCF/blob/master/results/UAVDT/quality_plot_error_OPE_threshold.png)
![image](https://github.com/HonglinChu/EFSCF/blob/master/results/UAVDT/quality_plot_overlap_OPE_AUC.png)

## VisDrone
![image](https://github.com/HonglinChu/EFSCF/blob/master/results/VisDrone/quality_plot_error_OPE_threshold.png)
![image](https://github.com/HonglinChu/EFSCF/blob/master/results/VisDrone/quality_plot_overlap_OPE_AUC.png)

# Reference


[1] Li, Feng et al. "Learning spatial-temporal regularized correlation filters for visual tracking."Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition. 2018: 4904-4913.

[2] Xu, Tianyang, et al. "Learning adaptive discriminative correlation filters via temporal consistency preserving spatial feature selection for robust visual object tracking." IEEE Transactions on Image Processing 28.11 (2019): 5596-5609.

[3] Huang, Ziyuan, et al. "Learning aberrance repressed correlation filters for real-time uav tracking." Proceedings of the IEEE International Conference on Computer Vision. 2019.

[4] Xu, Tianyang, et al. "Joint group feature selection and discriminative filter learning for robust visual object tracking." Proceedings of the IEEE International Conference on Computer Vision. 2019.

[5] Danelljan M, Bhat G, Khan F S, et al. ECO: Efficient Convolution Operators for Tracking.Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition.2017: 6931-6939.


# Acknowledgements
We thank the contribution of ARCF,STRCF,LADCF, GFSDCF,and ECO. Some of the parameter settings and functions are borrowed from ECO (https://github.com/martin-danelljan/ECO), STRCF (https://github.com/lifeng9472/STRCF) ,LADCF (https://github.com/XU-TIANYANG/LADCF).
