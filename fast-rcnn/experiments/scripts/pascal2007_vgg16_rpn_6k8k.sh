#!/bin/bash

set -x
set -e

export PYTHONUNBUFFERED="True"

LOG="experiments/logs/pascal2007_vgg16_rpn_6k8k.txt.`date +'%Y-%m-%d_%H-%M-%S'`"
exec &> >(tee -a "$LOG")
echo Logging output to "$LOG"

time ./tools/train_net.py --gpu $1 \
  --solver models/VGG16/pascal2007/solver_rpn_6k8k.prototxt \
  --weights data/imagenet_models/VGG16.v2.caffemodel \
  --imdb voc_2007_trainval \
  --cfg experiments/cfgs/pascal_rpn_vgg16.yml \
  --iters 80000

time ./tools/test_net.py --gpu $1 \
  --def models/VGG16/pascal2007/test_rpn.prototxt \
  --net output/pascal2007/voc_2007_trainval/vgg16_fast_rcnn_rpn_6k8k_pascal2007_iter_80000.caffemodel \
  --imdb voc_2007_test \
  --cfg experiments/cfgs/pascal_rpn_vgg16.yml

time ./tools/test_net.py --gpu $1 \
  --def models/VGG16/pascal2007/test_rpn.prototxt \
  --net output/pascal2007/voc_2007_trainval/vgg16_fast_rcnn_rpn_6k8k_pascal2007_iter_80000.caffemodel \
  --imdb voc_2007_trainval \
  --cfg experiments/cfgs/pascal_rpn_vgg16.yml
