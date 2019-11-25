# ESFS-CF

## ESFS-CF  is a tracker based on correlation filters for UAV tracking which can run 10fps on CPU.

Our algorithm will be open source in April 2020， and you can now download our results and test them on relevant data sets. Note that due to different operating environments, some algorithms may be inconsistent with the original results of the papers. Our own algorithms and other algorithms are re-tested on the same platform with ubuntu16.04, matlab2017b, matconvnet-1.0-beta25, opencv2.4.13,  GPU：NVIDIA-1080.

## We have tested our algorithm on UAV123，UAV20L, UAVDT，DTB70，Visdrone2019, OTB2015,OTB2013,OTB50 datasets and have achieved good performance compared to other algorithms.


| OTB50   | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 618  | 599   | 613   | 609    | 565  | 527  | 570  | 527   | 459  | 472  | 403  |
| P*1000  | 824  | 801   | 827   | 830    | 775  | 709  | 768  | 704   | 620  | 656  | 611  |



| OTB2013 | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 693  | 675   | 687   | 667    | 642  | 600  | 657  | 618   | 558  | 580  | 514  |
| P*1000  | 892  | 864   | 892   | 889    | 850  | 810  | 861  | 823   | 748  | 785  | 740  |



| OTB100  | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 675  | 664   | 657   | 644    | 617  | 585  | 621  | 591   | 518  | 555  | 477  |
| P*1000  | 875  | 864   | 865   | 858    | 818  | 776  | 824  | 776   | 689  | 754  | 696  |



| UAV_123 | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 500  | 494   | 478   | 505    | 470  | 458  | 458  | 459   | 410  | 395  | 331  |
| P*1000  | 712  | 702   | 678   | 724    | 674  | 655  | 656  | 665   | 590  | 576  | 523  |



| UAV20L  | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------  | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 438  | 445   | 416   | 419    | 396  | 344  | 419  | 426   | 339  | 329  | 265  |
| P*1000  | 587  | 593   | 560   | 547    | 559  | 491  | 583  | 579   | 469  | 455  | 406  |



| UAVDT   | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------  | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 478  | 431   | 418   | 431    | 470  | 454  | 439  | 428   | 405  | 336  | 293  |
| P*1000  | 750  | 662   | 638   | 718    | 740  | 717  | 704  | 690   | 702  | 591  | 575  |



| DTB70   | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------  | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 443  | 424   | 438   | 450    | 468  | 359  | 403  | 367   | 329  | 329  | 280  |
| P*1000  | 645  | 618   | 653   | 648    | 683  | 521  | 593  | 522   | 478  | 488  | 468  |



| VisDrone2019 | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | DSST | SAMF | KCF  | OURS |
| ----------   | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| S*1000       | 539  | 484   | 537   | 561    | 546  | 505  | 510  | 497  | 459  | 392  | 539  |
| P*1000       | 743  | 674   | 742   | 753    | 735  | 679  | 699  | 675  | 648  | 591  | 743  |


![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/p-uav123.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/s-uav123.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/p-UAVDT.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/s-UAVDT.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/p-DTB70.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/s-DTB70.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/p-visdrone2019.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/s-visdrone2019.png)

