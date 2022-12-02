# Gentoo ebuilds for GameDev

This is my Gentoo overlay for gamedev related ebuilds.
Ebuilds are cooking instructions for Gentoo systems
on how to fetch, build and install packages.

Current packages

- Panda3D


## Adding the repository

Please select the method of your preference.

### A) Eselect repository

TBA

### B) Manual

TBA

### C) Using Layman

Edit your `/etc/layman/layman.cfg` file to include the URL of my repositories.xml.
For example

```
overlays  :
    https://api.gentoo.org/overlays/repositories.xml
    https://raw.githubusercontent.com/jkemppainen/gamedev-joni-overlay/master/repositories.xml
```

Then, update all overlays and use Layman to add this overlay to your system.

```
layman -S
layman -a gamedev-joni-overlay
```

## Contributing

If you experience build failures and suspect they are caused by
the ebuild being faulty, please consider opening an issue
or making a pull request.

Same, if you think there could be some packages or features to be
added or changed.
