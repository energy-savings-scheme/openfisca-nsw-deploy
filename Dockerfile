FROM python:3.7

# Copy application bundle to DIR
COPY . /openfisca_nsw_api

#### Build API ####

# Set working directory
WORKDIR /openfisca_nsw_api

# Clone submodules from git
RUN git submodule init && git submodule update --recursive --remote

# Install openfisca-core `dependencies` branch
# NOTE - this is a temporary step while we wait for this branch to be merged into master
# RUN python -m pip install ./openfisca-core[web-api] --use-deprecated=legacy-resolver
# RUN python -m pip install openfisca_nsw_base --use-deprecated=legacy-resolver

# Install each country-package and extension
RUN python -m pip install -e ./openfisca_nsw_safeguard --use-deprecated=legacy-resolver

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
