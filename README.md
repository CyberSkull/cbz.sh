*cbz.sh* is a simple command line shell script (bash) to take a folder and turn it into a comic book zip archive (a zip archive with a `cbz` file name extension instead of `zip`).


### Dependancies
* `zsh` (orignally written for `bash`)
* `zip` (version 3)
* `afplay`

### Process
`cbz.sh` takes a list of file, check to see if they are readable folders, then passes each one to `zip` to compress it. `zip` will compress using DEFLATE at the highest compression setting, test the archive to ensure it is properly constructed, then delete the original folder (if it is empty, any unzipped files will be left behind; see the excluded files list below) and then move on to the next.

Finally, it will play a sound when finished.

### Usage
`cbz.sh` takes any kind of list of folders to convert to a cbz archive.

```zsh
cbz.sh [-k] comic1 [comic2…]

cbz.sh -h
```

#### Examples
```zsh
cbz.sh "comic by some dude" ["another comic by that guy"…]

cbz.sh comic*
```

The `-k` flag can be used to keep the file instead of immediately removing them on success.
```zsh
cbz.sh -k comic1 [comic2…]
```
The `-h` flag will print the usage and exit.


### Excluded files
* `.DS_Store` - Used by macOS to store folder metadata and appearance preferences.
* `Thumbs.db` - Used by Windows to store file preview thumbnails.
