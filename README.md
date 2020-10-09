<!-- # Neuromorphic Engineering Project
All the code for my master degree at ICNS -->

# Classification with FEAST network:

The aim of this analysis is to show the results of the event-based detection network on various recording conditions.

## 1st recording condition:

**Original video: Circles and lines which are well separated**


<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/CONDITION1_ORIGINALVIDEOShortGIF.gif" width="500">
</p>

**Labelled data**

Class label 1         |  Class label 0 - Everything else |
:-------------------------:|:-------------------------:|
[<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL1ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL1ShortGIF.gif) | [<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL0ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL0ShortGIF) |


### Network Structure: 

16F11x11-RF3x3 network (equivalent to a 16x16 feast neurons with 11x11 context using a 3x3 receptive field for spatial pooling with linear classifier)


**Final Results**

<p><span style="color:red">Red colour</span> represent events that are predicted to be circle</p>


<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/CONDITION1_FINALVIDEOoutputGIF.gif" width="500">
</p>

<table><thead><tr><th rowspan="2"></th><th colspan="2" rowspan="2">Accuracy</th><th colspan="2">Sensitivity</th><th colspan="2">Specificity</th><th colspan="2">Informedness</th></tr><tr><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td></tr></thead><tbody><tr><td>Linear Classifier</td><td colspan="2">89.49</td><td>0.6305</td><td>0.9590</td><td>0.9590</td><td>0.6305</td><td>0.5895</td><td>0.5895</td></tr></tbody></table>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/weightpropagation.svg" width="500">
</p>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/Confusionmatrix.svg" width="500">
</p>


## 2nd recording condition:

**Original video: Circles overlapping with each other**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition2/CONDITION2_ORIGINALVIDEOShortGIF.gif" width="500">
</p>


**Labelled data**

Class label 1         |  Class label 0 - Everything else |
:-------------------------:|:-------------------------:|
[<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition2/GROUDTRUTH_LABEL1ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL1ShortGIF.gif) | [<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition2/GROUDTRUTH_LABEL0ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL0ShortGIF) |

### Network Structure: 

16F11x11-RF3x3 network (equivalent to a 16x16 feast neurons with 11x11 context using a 3x3 receptive field for spatial pooling with linear classifier)

**Final Results: One weight for all classes**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition2/CONDITION2_FINALVIDEOoutputGIF.gif" width="500">
</p>


<table><thead><tr><th rowspan="2"></th><th colspan="2" rowspan="2">Accuracy</th><th colspan="2">Sensitivity</th><th colspan="2">Specificity</th><th colspan="2">Informedness</th></tr><tr><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td></tr></thead><tbody><tr><td>Linear Classifier</td><td colspan="2">75.61</td><td>0.5390</td><td>0.8720</td><td>0.8720</td><td>0.5390</td><td>0.4110</td><td>0.4110</td></tr></tbody></table>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition2/weightpropagation.svg" width="500">
</p>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition2/Confusionmatrix.svg" width="500">
</p>

**Final Results: Different weight for each class**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition2/CONDITION2_FINALVIDEOoutputGIF_SUPERVISORY_SIGNAL.gif" width="500">
</p>

<table><thead><tr><th rowspan="2"></th><th colspan="2" rowspan="2">Accuracy</th><th colspan="2">Sensitivity</th><th colspan="2">Specificity</th><th colspan="2">Informedness</th></tr><tr><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td></tr></thead><tbody><tr><td>Linear Classifier</td><td colspan="2">90.21</td><td>0.5677</td><td>0.9724</td><td>0.9724</td><td>0.5677</td><td>0.5402</td><td>0.5402</td></tr></tbody></table>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition2/weightpropagation_SUPERVISORY.svg" width="500">
</p>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition2/Confusionmatrix_SUPERVISORY.svg" width="500">
</p>

## 3rd recording condition:

**Original video: Circles between other geometrical shapes**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition3/CONDITION3_ORIGINALVIDEOShortGIF.gif" width="500">
</p>


**Labelled data**

Class label 1         |  Class label 0 - Everything else |
:-------------------------:|:-------------------------:|
[<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition3/GROUDTRUTH_LABEL1ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL1ShortGIF.gif) | [<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition3/GROUDTRUTH_LABEL0ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL0ShortGIF) |

### Network Structure: 

16F11x11-RF3x3 network (equivalent to a 16x16 feast neurons with 11x11 context using a 3x3 receptive field for spatial pooling with linear classifier)

**Final Results: One weight for all classes**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition3/CONDITION3_FINALVIDEOoutputGIF.gif" width="500">
</p>

<table><thead><tr><th rowspan="2"></th><th colspan="2" rowspan="2">Accuracy</th><th colspan="2">Sensitivity</th><th colspan="2">Specificity</th><th colspan="2">Informedness</th></tr><tr><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td></tr></thead><tbody><tr><td>Linear Classifier</td><td colspan="2">69.90</td><td>0.6167</td><td>0.7630</td><td>0.7630</td><td>0.6167</td><td>0.3797</td><td>0.3797</td></tr></tbody></table>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition3/weightpropagation.svg" width="500">
</p>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition3/Confusionmatrix.svg" width="500">
</p>

**Final results: Dedicated weight for each class with larger ROI**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition3/CONDITION3_FINALVIDEOoutputGIF_SUPERVISORY_SIGNAL.gif" width="500">
</p>

<table><thead><tr><th rowspan="2"></th><th colspan="2" rowspan="2">Accuracy</th><th colspan="2">Sensitivity</th><th colspan="2">Specificity</th><th colspan="2">Informedness</th></tr><tr><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td></tr></thead><tbody><tr><td>Linear Classifier</td><td colspan="2">80.12</td><td>0.2567</td><td>0.9536</td><td>0.9536</td><td>0.2567</td><td>0.2103</td><td>0.2103</td></tr></tbody></table>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition3/weightpropagation_SUPERVISORY.svg" width="500">
</p>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition3/Confusionmatrix_SUPERVISORY.svg" width="500">
</p>

## 4th recording condition:

**Original video: Circles overlapping with other class**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition4/CONDITION4_ORIGINALVIDEOShortGIF.gif" width="500">
</p>

**Labelled data**

Class label 1         |  Class label 0 - Everything else |
:-------------------------:|:-------------------------:|
[<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition4/GROUDTRUTH_LABEL1ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL1ShortGIF.gif) | [<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition4/GROUDTRUTH_LABEL0ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL0ShortGIF) |

### Network Structure: 

16F11x11-RF3x3 network (equivalent to a 16x16 feast neurons with 11x11 context using a 3x3 receptive field for spatial pooling with linear classifier)

**Final Results**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition4/CONDITION4_FINALVIDEOoutputGIF.gif" width="500">
</p>

<table><thead><tr><th rowspan="2"></th><th colspan="2" rowspan="2">Accuracy</th><th colspan="2">Sensitivity</th><th colspan="2">Specificity</th><th colspan="2">Informedness</th></tr><tr><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td></tr></thead><tbody><tr><td>Linear Classifier</td><td colspan="2">81.63</td><td>0.4602</td><td>0.9313</td><td>0.9313</td><td>0.4602</td><td>0.3915</td><td>0.3915</td></tr></tbody></table>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition4/weightpropagation.svg" width="500">
</p>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition4/Confusionmatrix.svg" width="500">
</p>


## 5th recording condition:

**Original video: Shaking the camera in front of a lemon tree**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE/HIE_ORIGINALVIDEOShortGIF.gif" width="500">
</p>


**Labelled data**

Class label 1        |  Class label 0 - Everything else |
:-------------------------:|:-------------------------:|
[<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE/GROUDTRUTH_LABEL1ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL1ShortGIF.gif) | [<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE/GROUDTRUTH_LABEL0ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL0ShortGIF) |

### Network Structure: 

16F11x11-RF3x3 network (equivalent to a 16x16 feast neurons with 11x11 context using a 3x3 receptive field for spatial pooling with linear classifier)

**Final Results**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE/HIE_FINALVIDEOoutputGIF.gif" width="500">
</p>

<table><thead><tr><th rowspan="2"></th><th colspan="2" rowspan="2">Accuracy</th><th colspan="2">Sensitivity</th><th colspan="2">Specificity</th><th colspan="2">Informedness</th></tr><tr><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td></tr></thead><tbody><tr><td>Linear Classifier</td><td colspan="2">94.09</td><td>0.1272</td><td>0.9984</td><td>0.9984</td><td>0.1272</td><td>0.1256</td><td>0.1256</td></tr></tbody></table>


<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE/weightpropagation.svg" width="500">
</p>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE/Confusionmatrix.svg" width="500">
</p>

## 6th recording condition:

**Original video: Slidding the camera through the lemon tree**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE2/HIE2_ORIGINALVIDEOShortGIF.gif" width="500">
</p>

**Labelled data**

Class label 1        |  Class label 0 - Everything else |
:-------------------------:|:-------------------------:|
[<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE2/GROUDTRUTH_LABEL1ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL1ShortGIF.gif) | [<img src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE2/GROUDTRUTH_LABEL0ShortGIF.gif" width="1000"/>](/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/Condition1/GROUDTRUTH_LABEL0ShortGIF) |

### Network Structure: 

16F11x11-RF3x3 network (equivalent to a 16x16 feast neurons with 11x11 context using a 3x3 receptive field for spatial pooling with linear classifier)

**Final Results**

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE2/HIE2_FINALVIDEOoutputGIF.gif" width="500">
</p>

<table><thead><tr><th rowspan="2"></th><th colspan="2" rowspan="2">Accuracy</th><th colspan="2">Sensitivity</th><th colspan="2">Specificity</th><th colspan="2">Informedness</th></tr><tr><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td><td>Class 1</td><td>Class 0</td></tr></thead><tbody><tr><td>Linear Classifier</td><td colspan="2">96.36</td><td>0.0002</td><td>0.9998</td><td>0.9998</td><td>0.0002</td><td>0.3982</td><td>0.3982</td></tr></tbody></table>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE2/weightpropagation.svg" width="500">
</p>

<p align="center">
  <img width="500" height="500" src="/home/sami/sami/Code/DeepGreen/greenhouseCode/recordings/Condition1234/HIE2/Confusionmatrix.svg" width="500">
</p>