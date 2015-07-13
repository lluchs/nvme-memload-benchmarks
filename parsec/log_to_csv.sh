#!/bin/bash

# Assume all headers are the same. Print only the first one.
sed -n '/^🕑HEAD,/{s///p;q}' <&0
# Print all content rows.
sed -n 's/^🕑,//p' <&0
