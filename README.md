## EFSCF

EFSCF is a tracker based on correlation filters for UAV tracking which can run at ~18fps on CPU. Our algorithm will open in  2020. Note that due to different configuration environment, some algorithms may be inconsistent with the original results of the papers. Our own algorithms and other algorithms are re-tested on the same platform with ubuntu16.04,matlab2017b,matconvnet-1.0-beta25,opencv2.4.13,GPU:NVIDIA-1080.

## Benchmark results

We have tested our algorithm on UAV123，UAV20L, UAVDT，Visdrone2019, OTB2015,OTB2013 datasets and have achieved good performance compared to other algorithms.


```bash
| OTB2013 | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 693  | 675   | 687   | 667    | 642  | 600  | 657  | 618   | 558  | 580  | 514  |
| P*1000  | 892  | 864   | 892   | 889    | 850  | 810  | 861  | 823   | 748  | 785  | 740  |
```

```bash
| OTB100  | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 675  | 664   | 657   | 644    | 617  | 585  | 621  | 591   | 518  | 555  | 477  |
| P*1000  | 875  | 864   | 865   | 858    | 818  | 776  | 824  | 776   | 689  | 754  | 696  |
```

```bash
| UAV_123 | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 509  | 494   | 478   | 505    | 470  | 458  | 458  | 459   | 410  | 395  | 331  |
| P*1000  | 712  | 702   | 678   | 724    | 674  | 655  | 656  | 665   | 590  | 576  | 523  |
```

```bash
| UAV20L | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------ | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000 | 452  | 445   | 416   | 419    | 396  | 344  | 397  | 343   | 270  | 317  | 196  |
| P*1000 | 604  | 593   | 560   | 547    | 559  | 491  | 554  | 507   | 459  | 457  | 311  |
```

```bash
| UAVDT   | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------  | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 478  | 431   | 418   | 431    | 470  | 454  | 439  | 428   | 405  | 336  | 293  |
| P*1000  | 750  | 662   | 638   | 718    | 740  | 717  | 704  | 690   | 702  | 591  | 575  |
```

```bash
| VisDrone19 | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | DSST | SAMF | KCF  | OURS |
| ---------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| S*1000     | 544  | 484   | 537   | 561    | 546  | 505  | 510  | 497  | 459  | 392  | 539  |
| P*1000     | 749  | 674   | 742   | 753    | 735  | 679  | 699  | 675  | 648  | 591  | 743  |
```

## Reference

[1] Li, Feng, et al. "Learning spatial-temporal regularized correlation filters for visual tracking." Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition. 2018.

[2] Xu, Tianyang, et al. "Learning adaptive discriminative correlation filters via temporal consistency preserving spatial feature selection for robust visual object tracking." IEEE Transactions on Image Processing 28.11 (2019): 5596-5609.

[3] Xu, Tianyang, et al. "Joint group feature selection and discriminative filter learning for robust visual object tracking." Proceedings of the IEEE International Conference on Computer Vision. 2019.

[4] Huang, Ziyuan, et al. "Learning aberrance repressed correlation filters for real-time uav tracking." Proceedings of the IEEE International Conference on Computer Vision. 2019.

