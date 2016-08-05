#Releasing Windows Installation Wizards using Inno Setup

Packages Needed
===============

* Inno Setup : http://www.jrsoftware.org/isdl.php
* Inno Script Studio : https://www.kymoto.org/products/inno-script-studio
* ISSI Library : http://members.home.nl/albartus/issi/

Instructions
===============

1. After installing the above packages, (ISSI to <code>C:\ISSI</code>), 
    you need to make 1 change to 1 file to use provided scripts.
    - Open <code>C:\ISSI\_issi.isi</code>
    - Go to line 4060
    - Change <code> function InitializeSetup(): Boolean;</code> to 
             <code> function InitializeSetupISSI(): Boolean;<code>.

2. Inside the InstallScripts folder are example scripts that use dependencies 
    in subdirectories. Open a script in "Inno Script Studio".

3. Change all the absolute paths to represent where they are on your machine.

4. Change the files you wish to include in the release, as well as the
    splash images, icons, package version, and unique ID for the package 
    (used for Windows registries).

5. The gear icon in studio with a play symbol compiles the install executable.

6. If there any errors, it will let you know where.
