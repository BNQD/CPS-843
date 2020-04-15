%%
disp ("Student A: Bao Doan 500733516");
disp ("Student B: Li Ne Li 500722909");


%% Setup
run('vlfeat-0.9.21/toolbox/vl_setup')


%% Face Detection 1.1 Generate training data
generate_cropped_notfaces;

%% 1.2 SVM Splitting done during train_svm function

%% 1.3 Generate HOG features
get_features;

%% 1.4 Train SVM on training set
train_svm;

%% 1.5 Validation Set - Done during train_svm;

%% 1.6 Recog Summary
recog_summary;

%% 2.2 - 2.5 Completed Detector
detect;

%% 2.6 Detect Summary
detect_summary;

%% Bonus
detect_class_faces;
