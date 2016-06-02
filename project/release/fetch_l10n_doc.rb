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
#EXTRACT TRANSLATED DOCUMENTATION FILES

if !(File.exists?("doc-translated") && File.directory?("doc-translated"))
    Dir.mkdir( "doc-translated" )
end

Dir.chdir( "doc-translated" )
topmakefile = File.new( "CMakeLists.txt", File::CREAT | File::RDWR | File::TRUNC )

i18nlangs.each_line do |lang|
    lang.chomp!()

    if (lang != nil && lang != "")

        print("#{lang} ")

        if !(File.exists?(lang) && File.directory?(lang))
            Dir.mkdir(lang)
        end

        Dir.chdir(lang)

        for part in ['color-management', 'credits-annex', 'editor-color', 'editor-decorate', 'editor-enhance', 'editor-filters', 'editor-transform', 'file-formats', 'ie-menu', 'index', 'menu-descriptions', 'photo-editing', 'sidebar']

            if isWindows
                `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/docs/extragear-graphics/digikam/#{part}.docbook > #{part}.docbook`
            else
                `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/docs/extragear-graphics/digikam/#{part}.docbook 2> /dev/null | tee #{part}.docbook`
            end
            if File.exists?("#{part}.docbook") and FileTest.size( "#{part}.docbook" ) == 0
                File.delete( "#{part}.docbook" )
            end
            makefile = File.new( "CMakeLists.txt", File::CREAT | File::RDWR | File::TRUNC )
            makefile << "KDOCTOOLS_CREATE_HANDBOOK( index.docbook INSTALL_DESTINATION ${HTML_INSTALL_DIR}/#{lang}/ SUBDIR digikam )"
            makefile.close()
        end

        Dir.chdir("..")
        topmakefile << "add_subdirectory( #{lang} )\n"
    end
end

puts ("\n")
