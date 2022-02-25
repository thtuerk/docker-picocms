# Docker Image for PicoCMS 

This is a dockerized version of PicoCMS (see http://picocms.org), a flat file content management system using Markdown. The image is based on the work of 
QNimbus https://github.com/QNimbus/docker-picocms.


## Basic Usage

Use the standard `docker-compose` commands.

### Build Image

`docker-compose build`

### Start

`docker-compose up -d`

### Stop

`docker-compose down`

### Accessing 
Once up and running, PicoCMS is available at http://localhost:8080. 


## Environment variables set in `docker-compose.yml`

If the environment variable `INSTALL_PICOCMS` is set to `YES` (the default), PicoCMS is copied to directory `./picocms`. 
This is usually fine, as it is uncommon to change existing PicoCMS files. However, if you intend to modify PicoCMS itself, remove the variable `ÌNSTALL_PICOCMS` from
`docker-compose.yml` to prevent your changes from being overwritten. 

Regardless of whether PicoCMS is installed, the owner of directory `./picocms` and all its files and subdictories is set to the user and group specified via the environemnt variables `N_UID` and `N_GID` specified in `docker-compose.yml`.
Changing `N_UID` and `N_GID` to match your own user, simplifies editing. 

## Using PicoCMS

Please refer to the [PicoCMS documentation](http://picocms.org/docs) for creating your own content, adding more themes, installing plugins, etc. For these tasks, the following sub-directories of `./picocms` are of particular interest:

- _plugins_ follow PicoCMS doc to [install plugins](http://picocms.org/docs/#plugins). ([Find more plugins](https://github.com/picocms/Pico/wiki/Pico-Plugins))
- _themes_ follow PicoCMS doc to [add or edit themes](http://picocms.org/docs/#themes). ([Find more themes](http://picocms.org/themes/))
- _content_ follow PicoCMS doc to [create content](http://picocms.org/docs/#creating-content)
- _config_ follow PicoCMS doc to [change configuration](http://picocms.org/docs/#config)

