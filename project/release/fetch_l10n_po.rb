#!/usr/bin/env ruby
#
# Ruby script for pulling l10n translations for digikam and kipi-plugins
# Requires ruby version >= 1.9
# 
# originally a Ruby script for generating Amarok tarball releases from KDE SVN
#
# Copyright (c)      2005, Mark Kretschmann, <kretschmann at kde dot org>
# Copyright (c)      2014, Nicolas Lécureuil, <kde at nicolaslecureuil dot fr>
# Copyright (c) 2010-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Some parts of this code taken from cvs2dist
# License: GNU General Public License V2

require 'rbconfig'
isWindows = RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/i

branch = "trunk"
tag = ""

unless $*.empty?()
    case $*[0]
        when "--branch"
            branch = `kdialog --inputbox "Enter branch name: " "branches/stable"`.chomp()
        when "--tag"
            tag = `kdialog --inputbox "Enter tag name: "`.chomp()
        else
            puts("Unknown option #{$1}. Use --branch or --tag.\n")
    end
end

# Using anonsvn so not necessary anymore
# Ask user for targeted application version
#user = `kdialog --inputbox "Your SVN user:"`.chomp()
#protocol = `kdialog --radiolist "Do you use https or svn+ssh?" https https 0 "svn+ssh" "svn+ssh" 1`.chomp()

i18nlangs = []

if isWindows
    i18nlangs = `type .\\project\\release\\subdirs`
else
    i18nlangs = `cat project/release/subdirs`
end

##########################################################################################
# EXTRACT TRANSLATED APPLICATION FILES

if !(File.exists?("po") && File.directory?("po"))
    Dir.mkdir( "po" )
end

Dir.chdir( "po" )
topmakefile = File.new( "CMakeLists.txt", File::CREAT | File::RDWR | File::TRUNC )

i18nlangs.each_line do |lang|

    lang.chomp!()

    if (lang != nil && lang != "")

        print ("#{lang} ")

        if !(File.exists?(lang) && File.directory?(lang))
            Dir.mkdir(lang)
        end

        Dir.chdir(lang)

        for part in ['digikam','kipiplugin_facebook','kipiplugin_flashexport','kipiplugin_flickr','kipiplugin_remotestorage','kipiplugin_googledrive','kipiplugin_piwigo','kipiplugin_printimages','kipiplugin_sendimages','kipiplugin_smug','kipiplugins','kipiplugin_dropbox','kipiplugin_imageshack','kipiplugin_imgur','kipiplugin_kmlexport', 'kipiplugin_rajce','kipiplugin_vkontakte','kipiplugin_wikimedia','kipiplugin_yandexfotki']

            if isWindows
                `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/messages/extragear-graphics/#{part}.po > #{part}.po`
            else
                `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/messages/extragear-graphics/#{part}.po 2> /dev/null | tee #{part}.po `
            end

            if FileTest.size( "#{part}.po" ) == 0
                File.delete( "#{part}.po" )
            end

            makefile = File.new( "CMakeLists.txt", File::CREAT | File::RDWR | File::TRUNC )
            makefile << "file(GLOB _po_files *.po)\n"
            makefile << "GETTEXT_PROCESS_PO_FILES( #{lang} ALL INSTALL_DESTINATION ${LOCALE_INSTALL_DIR} PO_FILES ${_po_files} )\n"
            makefile.close()
        end

        # libkvkontakte is in extragear-libs.

        for part in ['libkvkontakte']

            if isWindows
                `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/messages/extragear-libs/#{part}.po > #{part}.po `
            else
                `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/messages/extragear-libs/#{part}.po 2> /dev/null | tee #{part}.po `
            end

            if FileTest.size( "#{part}.po" ) == 0
                File.delete( "#{part}.po" )
            end
        end

        Dir.chdir("..")
        topmakefile << "add_subdirectory( #{lang} )\n"
    end
end

puts ("\n")
