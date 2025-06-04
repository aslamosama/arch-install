#!/usr/bin/env sh

# Restore personal backup of fonts
unzip ~/backup/font_backup.zip -d ~/.local/share/fonts

# Make essential fonts avaible to fontconfig from Texlive installation
ln -s /usr/share/texmf-dist/fonts/opentype/gnome/cantarell ~/.local/share/fonts/cantarell
ln -s /usr/share/texmf-dist/fonts/truetype/public/dejavu ~/.local/share/fonts/dejavu
ln -s /usr/share/texmf-dist/fonts/opentype/public/fontawesome ~/.local/share/fonts/fontawesome
ln -s /usr/share/texmf-dist/fonts/opentype/public/garamond-libre ~/.local/share/fonts/garamond-libre
ln -s /usr/share/texmf-dist/fonts/opentype/public/garamond-math ~/.local/share/fonts/garamond-math
ln -s /usr/share/texmf-dist/fonts/opentype/public/gfsbodoni ~/.local/share/fonts/gfsbodoni
ln -s /usr/share/texmf-dist/fonts/opentype/public/gfsdidot ~/.local/share/fonts/gfsdidot
ln -s /usr/share/texmf-dist/fonts/opentype/public/inconsolata ~/.local/share/fonts/inconsolata
ln -s /usr/share/texmf-dist/fonts/opentype/public/inter ~/.local/share/fonts/inter
ln -s /usr/share/texmf-dist/fonts/opentype/public/kpfonts-otf ~/.local/share/fonts/kpfonts
ln -s /usr/share/texmf-dist/fonts/truetype/typoland/lato ~/.local/share/fonts/lato
ln -s /usr/share/texmf-dist/fonts/opentype/public/libertine ~/.local/share/fonts/libertine
ln -s /usr/share/texmf-dist/fonts/opentype/public/libertinus-fonts ~/.local/share/fonts/libertinus
ln -s /usr/share/texmf-dist/fonts/truetype/impallari/librebaskerville ~/.local/share/fonts/librebaskerville
ln -s /usr/share/texmf-dist/fonts/opentype/public/montserrat ~/.local/share/fonts/montserrat
ln -s /usr/share/texmf-dist/fonts/opentype/public/newcomputermodern ~/.local/share/fonts/newcomputermodern
ln -s /usr/share/texmf-dist/fonts/truetype/ascender/opensans ~/.local/share/fonts/opensans
ln -s /usr/share/texmf-dist/fonts/opentype/ibm/plex ~/.local/share/fonts/plex
ln -s /usr/share/texmf-dist/fonts/opentype/adobe/sourcecodepro ~/.local/share/fonts/sourcecodepro
ln -s /usr/share/texmf-dist/fonts/opentype/adobe/sourcesanspro ~/.local/share/fonts/sourcesanspro
ln -s /usr/share/texmf-dist/fonts/opentype/adobe/sourceserifpro ~/.local/share/fonts/sourceserifpro
ln -s /usr/share/texmf-dist/fonts/opentype/public/stix2-otf ~/.local/share/fonts/stix2-otf
ln -s /usr/share/texmf-dist/fonts/opentype/public/tex-gyre ~/.local/share/fonts/tex-gyre
ln -s /usr/share/texmf-dist/fonts/opentype/public/tex-gyre-math ~/.local/share/fonts/tex-gyre-math
fc-cache -v
