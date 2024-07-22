This is the code file corresponding to the paper: Glypred: Lysine glycation site prediction based on CCU-LightGBM-BiLSTM modeling  
Description of each file in GitHub  
（1）Train_MATLAB: Contains the training code based on MATLAB.  
（2）Train_PyTorch: Provides the training code implemented using the PyTorch framework.  
（3）Predictor: Includes the integrated predictor.  

Usage of Glypred
1 The researcher needs to store the protein sequence to be predicted into a “.txt” file, the first line stores the name of the protein sequence, the second line is the long sequence of the protein to be predicted.  
2 The researchers then opened the downloaded predictor software, clicked the “Upload” button, and selected the corresponding protein sequence file.
3 After the file is uploaded, the program will automatically parse the protein sequence, and after parsing, it will cut the whole sequence with a window size of “31”, and if it is less than the window size, it will be supplemented with “O”. Eventually, the whole sequence will be cut into multiple sub-sequences with a window size of 31, and the trained model will be called to make predictions. The predicted content will be presented on the interface, including the number of the position where glycation occurs (which position in the whole sequence has a higher probability of lysine glycation), the predicted probability (with a threshold of 0.5, greater than 0.5 is predicted to be glycation, less than 0.5 is predicted to be non-glycation), and the predicted result (glycation or non-glycation).  
4 After the prediction is done, click on the “Export” button, select the location where you want to store it, name the file, and then the file will save the final prediction in the form of excel.  
5 The final forecast content will be saved to the excel table, find the pre-saved location, you can view the content.  





  

