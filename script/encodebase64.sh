#!/bin/bash

for i in $(cat $1); do
        echo $i | base64 >> $2
done


