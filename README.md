Chef Environment Powershell script
==================
This script setting up Chef environment (Chef client, Git, Ruby) for automation on your local machine. <br>

Usage
==================
You can install it from existing files, saved on your local machine or download from internet any valid version. <br>
Default Installation is by existing files: <br>
$webDownload = 1

If you wish to install it from Internet, just set: <br>
$webDownload = 0

Any valid version, you can find on the next links of relevant Vendors: <br>

* Git: 'https://github.com/git-for-windows/git/releases/tag/v2.7.4.windows.1' <br>
* Chef: 'https://downloads.chef.io/chef-client/windows/' <br>
* Ruby & DevKit: 'http://dl.bintray.com/oneclick/rubyinstaller/' <br>

Just set your file/version, for example:

* $gitFile = "Git-2.7.4-64-bit.exe"
* $chefClientFile = "chef-client-12.7.2-1-x86.msi"
* $rubyFile = "rubyinstaller-2.2.4.exe"
* $installRubyPath = "C:\Ruby22"
* $devKitFile = "DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe"	
 
Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Michael Vershinin

Support
-------------------
goldver@gmail.com