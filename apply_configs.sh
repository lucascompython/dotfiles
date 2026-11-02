#!/bin/bash


echo "Applying zed config..."
cp -a ./zed/. ~/.config/zed/


echo "Applying nvim config..."
rsync -a --exclude=.git ./config/nvim/ ~/.config/nvim/
