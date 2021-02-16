FROM python:3.7

# Copy application bundle to DIR
COPY . /openfisca_nsw_api

#### Build API ####

# Set working directory
WORKDIR /openfisca_nsw_api

# Clone submodules from git
RUN git submodule init && git submodule update

# Install each country-package and extension
RUN python -m pip install ./openfisca_nsw_base/
RUN python -m pip install ./openfisca_nsw_ess_nabers/

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]