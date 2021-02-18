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
RUN python -m pip install ./openfisca-core/

# Install each country-package and extension
RUN python -m pip install ./openfisca_nsw_base/
RUN python -m pip install ./openfisca_nsw_ess_nabers/
RUN python -m pip install ./openfisca_nsw_ess_heer/
RUN python -m pip install ./openfisca-nsw-ess-sandbox/

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
