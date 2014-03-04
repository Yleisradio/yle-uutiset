This a Yle News site template that allows users to test their applications in genuine environment.

## Author

Teemo Tebest (Yle), @teelmo @IRCnet

## Requirements

- Web server (for example Apache)
- PHP

## Usage

- Clone the project.
- Create a virtual host that points to the cloned folder.
- Browse to your virtual host. For example http://yle.dev/

## Example set up

This section describes shortly an example set up.

**Apache Virtual host set up**

    <VirtualHost *:80>
    DocumentRoot "/Users/teelmo/Documents/Yle"
    ServerName yle.dev
    ServerAlias *.yle.dev
    ErrorLog "/var/log/apache2/yle.local-error_log"
    CustomLog "/var/log/apache2/yle.local-access_log" common
    <directory /Users/teelmo/Documents/Yle>
    Order Allow,Deny
    Allow from All
    AllowOverride All
    Options Indexes FollowSymlinks Multiviews
    </directory>
    </VirtualHost>

**Localhost definition**

<code>
127.0.0.1       yle.dev
</code>

**Example project**

New projects go to individual folders and can be accessed via browser

http://yle.dev/?f={folder}

**For example**

http://yle.dev/?f=case-2013/Esi-template
