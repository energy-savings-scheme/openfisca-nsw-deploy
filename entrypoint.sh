#!/bin/bash

/usr/local/bin/openfisca serve --workers=3 --country-package openfisca_nsw_base --extensions openfisca_nsw_ess_heer openfisca_nsw_pdrs --bind 0.0.0.0:$PORT
