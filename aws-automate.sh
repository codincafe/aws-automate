#!/bin/bash
# Shell script to install required AWS CLI tools and setup bash environment
# -------------------------------------------------------------------------
# Copyright (c) 2004 CodeHive <http://www.codincafe.com/>
# This script is licensed under GNU GPL version 2.0 or above, and is
# distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
# PARTICULAR PURPOSE.
# -------------------------------------------------------------------------
# Inspired and adapted from Geoffrey Hoffman (http://www.cardinalpath.com/author/ghoffman/)
# and Steven Rose (http://www.cardinalpath.com/author/srose/)
# Further reading: http://www.cardinalpath.com/autoscaling-your-website-with-amazon-web-services-part-1/
# -------------------------------------------------------------------------

if [ $# -lt 2 ]
then
  echo "Usage: $0 path-to-certificate path-to-private-key"
  exit 0
fi

mkdir -p $HOME/amazon/{ami,as,cw,ec2}

cp $1 $HOME/amazon
cp $2 $HOME/amazon

wget -c -P $HOME/amazon/ami http://codincafe.com/downloads/ec2-ami-tools.zip
cd $HOME/amazon/ami/
unzip `ls *.zip`
cd $HOME/amazon/ami/*
find . -mindepth 1 -maxdepth 1 -exec mv -t.. -- {} +
cd ..
rm -rf ec2*
clear

wget -c -P $HOME/amazon/ec2 http://codincafe.com/downloads/ec2-api-tools.zip
cd $HOME/amazon/ec2/
unzip `ls *.zip`
cd $HOME/amazon/ec2/*
find . -mindepth 1 -maxdepth 1 -exec mv -t.. -- {} +
cd ..
rm -rf ec2*
clear

wget -c -P $HOME/amazon/as http://codincafe.com/downloads/AutoScaling-2011-01-01.zip
cd $HOME/amazon/as/
unzip `ls *.zip`
cd $HOME/amazon/as/*
find . -mindepth 1 -maxdepth 1 -exec mv -t.. -- {} +
cd ..
rm -rf AutoScaling*
clear

wget -c -P $HOME/amazon/cw http://codincafe.com/downloads/CloudWatch-2010-08-01.zip
cd $HOME/amazon/cw/
unzip `ls *.zip`
cd $HOME/amazon/cw/*
find . -mindepth 1 -maxdepth 1 -exec mv -t.. -- {} +
cd ..
rm -rf CloudWatch*
clear

cp -R $HOME/amazon/ec2/bin $HOME/amazon/ec2/lib $HOME/amazon/
echo

clear

echo "#AWS Config Start
export EC2_HOME=~/amazon/ec2
export EC2_PRIVATE_KEY=\`ls ~/amazon/pk-*.pem\`
export EC2_CERT=\`ls ~/amazon/cert-*.pem\`
export AWS_AUTO_SCALING_HOME=~/amazon/as
export AWS_CLOUDWATCH_HOME=~/amazon/cw
export AWS_AMITOOLS_HOME=~/amazon/ami
export PATH=\$PATH:\$EC2_HOME/bin:\$AWS_AUTO_SCALING_HOME/bin:\$AWS_CLOUDWATCH_HOME/bin:\$AWS_AMITOOLS_HOME/bin
export JAVA_HOME=/usr
#AWS Config End
" |cat - $HOME/.bashrc > /tmp/out && mv /tmp/out $HOME/.bashrc

source $HOME/.bashrc

if command -v as-version >/dev/null; then
        echo "AWS Tools Install Success"
else
        echo "Some Issues"
fi

exit 0