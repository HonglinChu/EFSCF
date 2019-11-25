# ESFS-CF

## ESFS-CF  is a tracker based on correlation filters for UAV tracking which can run 10fps on CPU.

Our algorithm will be open source in April 2020， and you can now download our results and test them on relevant data sets. Note that due to different operating environments, some algorithms may be inconsistent with the original results of the papers. Our own algorithms and other algorithms are re-tested on the same platform with ubuntu16.04, matlab2017b, matconvnet-1.0-beta25, opencv2.4.13,  GPU：NVIDIA-1080.

## We have tested our algorithm on UAV123，UAV20L, UAVDT，DTB70，Visdrone2019, OTB2015,OTB2013,OTB50 datasets and have achieved good performance compared to other algorithms.

| OTB100 | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| -------| ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000 | 675  | 664   | 657   | 644    | 617  | 585  | 621  | 591   | 518  | 555  | 477  |
| P*1000 | 875  | 864   | 865   | 858    | 818  | 776  | 824  | 776   | 689  | 754  | 696  |

| OTB2013 | OURS | LADCF | STRCF | ECO_HC | ARCF | AMCF | BACF | SRDCF | DSST | SAMF | KCF  |
| ------- | ---- | ----- | ----- | ------ | ---- | ---- | ---- | ----- | ---- | ---- | ---- |
| S*1000  | 693  | 675   | 687   | 667    | 642  | 600  | 657  | 618   | 558  | 580  | 514  |
| P*1000  | 892  | 864   | 892   | 889    | 850  | 810  | 861  | 823   | 748  | 785  | 740  |





![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/p-uav123.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/s-uav123.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/p-UAVDT.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/s-UAVDT.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/p-DTB70.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/s-DTB70.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/p-visdrone2019.png)
![image](https://github.com/xiaogeaihighying/ESFS-CF/blob/master/picture/s-visdrone2019.png)

