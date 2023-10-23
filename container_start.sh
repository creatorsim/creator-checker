#!/bin/bash
set -x

sudo docker build -t creator_corrector .

sudo docker run -v $(pwd)/ec_p1_corrector/:/ec_p1_corrector/ -it creator_corrector /bin/bash

