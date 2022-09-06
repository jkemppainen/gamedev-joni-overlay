# Gentoo ebuilds for GameDev

This repostitory my ebuild repository for gamedev.
Currently it contains

- Panda3D


## Adding the repository

### A) Using Layman

Edit your `/etc/layman/layman.cfg` file to include my overlay listing as follows

```
overlays  :
    https://api.gentoo.org/overlays/repositories.xml
    https://raw.githubusercontent.com/jkemppainen/gamedev-joni-overlay/master/repositories.xml
```

Then, use Layman to add this overlay to your system.

```
layman -a gamedev-joni-overlay
```

## Contributing

If you experience build failures and suspect that they are due to
faulty ebuilds, please feel free to open an issue
(or a pull request).

Same if you think there could be something added.
