# emacs-docker
## Tags
- `26.2`

## Usage
```bash
$ docker pull bamboo130/emacs:26.2
$ docker run --rm -it bamboo130/emacs:26.2

emacser@XXXX:/work-dir$ emacs
```

### Options
#### for docker run
- -v `<Your .emacs.d path>`:/dot.emacs.d
- -v `<Your working directory>`:/work-dir

### Environment Variables
#### `EMACS_USER`
コンテナ内のユーザ名 (Default は `emacser`)
#### `EMACS_UID`
`EMACS_USER` の UID (Default は `99999`)
#### `EMACS_GID`
`EMACS_USER` の GID (Default は `99999`)

