# Gentoo ebuilds for GameDev

This is my Gentoo overlay for gamedev related ebuilds.
Ebuilds are cooking instructions for Gentoo systems
on how to fetch, build and install packages.

Current packages

- Panda3D


## Adding the repository

Please select one of the following.

### A) Eselect repository (recommended)

```bash
eselect repository add gamedev-joni-overlay git https://github.com/jkemppainen/gamedev-joni-overlay
emaint sync --repo gamedev-joni-overlay
```

### B) Layman (deprecated)

Layman is due to removal in Gentoo.

Edit your `/etc/layman/layman.cfg` file to include the URL of my repositories.xml.
For example

```
overlays  :
    https://api.gentoo.org/overlays/repositories.xml
    https://raw.githubusercontent.com/jkemppainen/gamedev-joni-overlay/master/repositories.xml
```

Then, update all overlays and use Layman to add this overlay to your system.

```bash
layman -S
layman -a gamedev-joni-overlay
```

## Contributing

If you experience build failures and suspect they are caused by
the ebuild being faulty, please consider opening an issue
or making a pull request.

Same, if you think there could be some packages or features to be
added or changed.
