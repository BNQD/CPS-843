%run('../vlfeat-0.9.20/toolbox/vl_setup')
load('pos_neg_feats.mat')

training_pos_feats = pos_feats (1:round(size(pos_feats, 1) * 0.8), :);
training_neg_feats = neg_feats (1:round(size(neg_feats, 1) * 0.8), :);

validation_pos_feats = pos_feats (round(size(pos_feats, 1) * 0.8) + 1:end, :);
validation_neg_feats = neg_feats (round(size(neg_feats, 1) * 0.8) + 1:end, :);

feats = cat(1,training_pos_feats,training_neg_feats);
labels = cat(1,ones(round(pos_nImages * 0.8),1),-1*ones(round(neg_nImages * 0.8),1));

lambda = 0.001;
[w,b] = vl_svmtrain(feats',labels',lambda);

fprintf('Classifier performance on train data:\n')
confidences = [training_pos_feats; training_neg_feats]*w + b;

[tp_rate, fp_rate, tn_rate, fn_rate] =  report_accuracy(confidences, labels);


%% Test on validation set

confidences = [validation_pos_feats; validation_neg_feats] * w + b;
labels = cat(1,ones(pos_nImages - round(pos_nImages * 0.8),1),-1*ones(neg_nImages - round(neg_nImages * 0.8),1));

[tp_rate, fp_rate, tn_rate, fn_rate] =  report_accuracy(confidences, labels);

save('my_svm.mat','w','b');
