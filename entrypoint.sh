#!/bin/bash

/usr/local/bin/openfisca serve --workers=4 --country-package openfisca_nsw_base --extensions openfisca_nsw_ess_nabers openfisca_nsw_ess_heer openfisca_nsw_ess_sandbox --bind 0.0.0.0:$PORT
