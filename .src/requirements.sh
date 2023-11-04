#! /bin/sh

for d in `cat requirements.txt`; do

  poetry add $d

done

# poetry export --without-hashes -o requirements.txt

# pip install -r requirements.txt