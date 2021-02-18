_Readme updated 17-Feb-2021_

# openfisca-nsw-deploy
**`energy-savings-scheme/openfisca-nsw-deploy` establishes a CD (continuous deployment) pipeline for the OpenFisca API stack for the DPIE Energy Security Safeguard team.** This repo is:
- Is linked to ESS OpenFisca Github Repos via git [submodules](https://gist.github.com/gitaarik/8735255). These submodule repos contain the OpenFisca "country-packs" and "extensions" relevant to this ESS ruleset deployment.
- Bundles the OpenFisca API and deploys to Heroku.


## Continuous Deployment Pipeline
#### Config
- The config is stored in [`.github/workflows/heroku-deploy.yaml`](https://github.com/energy-savings-scheme/openfisca-nsw-deploy/blob/master/.github/workflows/heroku-deploy.yml)
- This workflow is triggered by either of two events: 
   - `workflow_dispatch`: triggered manually by clicking the "Run workflow" button (on the ['Actions' tab](https://github.com/energy-savings-scheme/openfisca-nsw-deploy/actions))
   - `repository_dispatch`: triggered automatically when a child submodule is updated

#### What does this workflow do?
1) Checks out the repo
2) Builds a Docker image as per the `Dockerfile` file
   - Clones the latest versions of the specified submodules
   - Installs each submodule (the install order is important!)
   - Runs the `entrypoint.sh` file, which just serves the OpenFisca API on a port which is exposed to the internet
3) Pushes the Docker image to Heroku Container Registry
4) Rebuilds the Heroku dyno using the new Docker image

#### How do I add more submodules?
You may want to add more submodules. A typical use-case is to include another OpenFisca Extension to this API deployment.

1. Add a submodule to the repo:
```sh
# Clone the repo to your local machine
# Open a Terminal in the working directory
$ git submodule add --name <desired_submodule_name> --branch <branch_name (optional)> <repo_url (required)> 
$ git commit -a
$ git push origin master

# for example: git submodule add https://github.com/tjharrop/openfisca_nsw_base.git --name openfisca_nsw_base
```

2. Update the Heroku build config:
```
# You must updated the `DOCKERFILE` and `entrypoint.sh` otherwise the new submodule will not be installed into the Docker container and served on the Heroku dyno...
1) Add a RUN command to `pip install` the new submodule
2) Update the `openfisca serve` command in to include the new "country-package" or "extension"
```

3. Trigger a manual deployment
   - On the Github repo page, go to the "Actions" tab, click the `HerokuBuildAndDeploy` workflow. Click "Run workflow" button.


#### How is the 'repository_dispatch' event triggered?
The relevant submodules should have their own Github pipepline which dispatches a [repository_dispatch](https://docs.github.com/en/actions/reference/events-that-trigger-workflows#repository_dispatch) event when they are updated. The example below demonstrates how the "openfisca_nsw_base" submodule dispatches the 'repository_dispatch' event:
- We create a Github Actions pipeline in the "openfisca_nsw_base" repo which sends a 'repository_dispatch' event to the `energy-savings-scheme/openfisca-nsw-deploy` repo
```sh
# EXAMPLE GITHUB ACTIONS WORKFLOW IN THE **SUBMODULE** REPO
  on:
    push:
      branches: [master]
    pull_request:
      branches: [master]
  jobs:
    ... <earlier jobs here>
    
    build:
      runs-on: ubuntu-latest
      steps:
      - name: Repository Dispatch
        uses: peter-evans/repository-dispatch@v1
        with:
          token: ${{ secrets.CR_PAT }}
          repository: energy-savings-scheme/openfisca-nsw-deploy
          event-type: submodule-updated ### Note!! the type must be "submodule-updated"
```
Notes:
- You must set the `secrets.CR_PAT` within the submodule repo's settings, otherwise you will receive a permission error. The `CR_PAT` value should be a Github Personal Access Token from a user with access to the `energy-savings-scheme/openfisca-nsw-deploy` repo.
- Note - We don't necessarily want to listen for Pushes to **all** submodules. For instance, the `openfisca_core` submodule is updated infrequently, so we can manage this manually. Besides, we are not the owner of that repo so we can't create a Github actions workflow anyway...

## Running the Docker container locally
You can also run this deployment on a local docker container.

```sh
  git submodule init && git submodule update
  docker build -f Dockerfile -t api_test .
  docker run -p 8000:80 api_test
```

