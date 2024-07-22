# Panwah Wallpapers
Wallpapers for Panwah.

## Build dependencies
* Bash
* inkscape
* dirname (coreutils)
* tar (Optional, for compress on tar.gz)
* gzip (Optional, for compress on tar.gz, tar is required)

Example of installation of dependencies, required sudo or root account
> In Arch Linux or derivatives
```
pacman -S bash inkscape coreutils tar gzip
```

## Usage
```
./WallPack.sh --sha256sums --packtargz
```

## Error codes
| Exit code	| Cause					|
| --- 		| ---					|
| 0		| Normal exit.				|
| 1		| Dependencie not found.		|
| 2		| Only can compile in some path.	|
| 3		| Exiting *.png files.			|

## License
This project is licensed under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/). <br>
For more details, see the [full license text](LICENSE). <br>
© 2024 Isaac David Orozco Delgado
