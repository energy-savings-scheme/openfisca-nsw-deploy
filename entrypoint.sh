#!/bin/bash

/usr/local/bin/openfisca serve --workers=4 --country-package openfisca_nsw_base --extensions openfisca_nsw_ess_nabers --extensions openfisca_nsw_ess_heer --bind 0.0.0.0:$PORT
