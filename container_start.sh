#!/bin/bash
set -x

docker build -t creator_checker .

docker run -v $(pwd)/ec_p1_corrector/:/ec_p1_corrector/ -it creator_checker /bin/bash
