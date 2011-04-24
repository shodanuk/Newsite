# newsite.sh

Sets up a new site on Mac OSx Snow Leopard.

* Creates site root folder
* Sets up a new Virtual Host
* Adds an entry to the hosts file
* Restarts apache

## Usage

1. Update all config options at the top of newsite.sh to suit your system and requirements
2. Move (or symlink) newsite.sh and default.txt to /usr/bin (or somewhere appropriate)
3. Then run:
```
sudo newsite.sh sitename
```

newsite.sh will create:

* ~/Sites/sitename folder
* sitename.conf in /etc/apache2/other
* 127.0.0.1 sitename.localhost in /etc/hosts

## MIT Licence

Copyright (c) 2011 Terry Morgan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.