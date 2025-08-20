# Dual-Way Streaming PARAFAC2 Decomposition Method for Irregular Tensors - Algorithm and Application
This is a code for "Dual-Way Streaming PARAFAC2 Decomposition Method for Irregular Tensors - Algorithm and Application", published in KDD 2023.

## Code Information
All codes are written by MATLAB 2020b.
This repository contains the code for Dash (Dual-wAy Streaming PARAFAC2 decomposition metHod for irregular tensors), an efficient method for PARAFAC2 decomposition in a dual-way streaming setting. Given pre-existing factor matrices, new rows of existing slice matrices, and new slice matrices Dash efficiently updates factor matrices by carefully avoiding the computations involved with an accumulated tensor.
Our code requires Tensor Toolbox version 3.0 (available at https://gitlab.com/tensors/tensor_toolbox, put the tensor toolbox folder in `library` directory after downloading the tensor toolbox library).

* The code of Dash is in `src` directory.
    * `dash_initial.m`: the code related to the initialization to find initial factor matrices before dynamic updates.
    * `dash_update.m`: the code related to updating factor matrices when new rows of existing slice matrices and new slice matrices are given.
    * `updateU.m`: the code related to updating the factor matrix U when new rows of existing slice matrices and new slice matrices are given.
    * `updateS`: the code related to updating the factor matrix S when new rows of existing slice matrices and new slice matrices are given.
    * `updateV`: the code related to updating the factor matrix V when new rows of existing slice matrices and new slice matrices are given.
* The libraries used for Dash are in `library` directory.


## How to run for real-world data
We used 6 real-world irregular tensor datasets in the experiment.
Among them, we provide two demo scripts for KR and JPN Stock datasets due to the limited storage.
First, you download the Stock datasets from [link](https://drive.google.com/file/d/1Fp2svqL_P8m3wDSRWC8IfqLim0dmaKsY/view?usp=share_link), extract the zip file, and move the extracted folder to home directory of this repository.
Then, type the following command to run the demo code for the given data:  
   
   `run demo_kr.m`

Or, 

   `run demo_jpn.m`

Note that you should modify the path of data in `demo_kr.m` or `demo_jpn.m` file, appropriately if the code does not run.

## Reference
If you use this code, please cite the following paper.
```
@inproceedings{jang2023fast,
  title={Fast and accurate dual-way streaming parafac2 for irregular tensors-algorithm and application},
  author={Jang, Jun-Gi and Lee, Jeongyoung and Park, Yong-chan and Kang, U},
  booktitle={Proceedings of the 29th ACM SIGKDD Conference on Knowledge Discovery and Data Mining},
  pages={879--890},
  year={2023}
}
```
