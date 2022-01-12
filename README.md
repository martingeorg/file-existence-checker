# File existence checker

## What it is, how does it work and why it exists
- Looks for files, which are present in **folder1** *(first argument)*, but are missing in **folder2** *(second argument)*
- Doesn't care for the files location
- Doesn't care for any files which are present in folder2, but not in folder1
- Compares the files hashes
- Only files are reported, folders are ignored
- Works on `*nix` operating systems and requires/relies on `bash`, `find`, GNU `parallel`, `sha1sum` or `md5sum`, `awk` and `grep`
- It's **not** a folder synchronization tool, use [FreeFileSync](https://freefilesync.org/) for that
- It covers a case which [FreeFileSync](https://freefilesync.org/) can't. That is, check if files from the first folder are present **anywhere** in the second folder
- It's **not** a duplicate files removal tool, use [fslint](https://snapcraft.io/install/fslint-unofficial/ubuntu), [rdfind](http://manpages.ubuntu.com/manpages/trusty/man1/rdfind.1.html) or some other tool for that

## Usage

Let's say we've **copied + reorganized** files from `some-folder` into `some-other-folder`.

Now we want to make sure that all files present in `some-folder` are also present in `some-other-folder`, regardless of their location in any of the two folders.
```
./find-missing-files-in-second-folder.sh ../some-folder/ ../some-other-folder/
```

## Warning

- The script hasn't been battle tested yet. Use at own risc, of having false positives for files existence

## Todo
- Implement second script which copies files to the second folder, maybe try to preserve paths even if that's done within some special folder
- Do some tests with symlinks. Currently the behavior is unknown/untested
- Compare execution speed between `sha1sum` and `md5sum`. Are they reliable enough?
- Include file size check along with the hash check
