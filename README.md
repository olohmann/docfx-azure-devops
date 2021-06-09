# DocFX Sample

This DocFX sample demonstrates how to build and containerize a DocFX repository.

Simply create a new pipeline, utilizing the `azure-pipelines.yml` as a template. Update the Azure Service Connection and other arguments accordingly.

## TODOs

* Remember to create a Azure Service Connection if you want to push the docker container to the Azure Container Registry.
* Update the pipeline YAML with the right Azure Container Registry instance and update the image name + tag name.
* The sample Dockerfile should be converted into a non-root nginx setup.
