#!/usr/bin/env ruby
#
# Ruby script for pulling l10n application translations for digikam
# Requires ruby version >= 1.9
#
# Copyright (c)      2005, Mark Kretschmann, <kretschmann at kde dot org>
# Copyright (c)      2014, Nicolas Lécureuil, <kde at nicolaslecureuil dot fr>
# Copyright (c) 2010-2016, Gilles Caulier, <caulier dot gilles at gmail dot com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

require 'rbconfig'
isWindows = RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/i

branch = "trunk"
tag = ""

enable_digikam = false
enable_kipiplugins = false
enable_libkvkontakte = false

for opt in $*

    case opt
        when "--enable-digikam"
            enable_digikam = true
        when "--enable-kipiplugins"
            enable_kipiplugins = true
        when "--enable-libkvkontakte"
            enable_libkvkontakte = true
        else
            puts("Unknown option '#{opt}'.\n")
            puts("Possible arguments to customize i18n extraction:\n")
            puts("--enable-digikam\n")
            puts("--enable-kipiplugins\n")
            puts("--enable-libkvkontakte\n")
            exit
    end
end

print ("extract digiKam i18n      : #{enable_digikam}\n")
print ("extract kipiplugins i18n  : #{enable_kipiplugins}\n")
print ("extract libkvkontakte i18n: #{enable_libkvkontakte}\n")

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

        makefile = File.new( "CMakeLists.txt", File::CREAT | File::RDWR | File::TRUNC )
        makefile << "file(GLOB _po_files *.po)\n"
        makefile << "GETTEXT_PROCESS_PO_FILES( #{lang} ALL INSTALL_DESTINATION ${LOCALE_INSTALL_DIR} PO_FILES ${_po_files} )\n"
        makefile.close()

        if (enable_digikam == true)

            # digiKam core extragear-graphics

            for part in ['digikam']

                if isWindows
                    `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/messages/extragear-graphics/#{part}.po > #{part}.po`
                else
                    `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/messages/extragear-graphics/#{part}.po 2> /dev/null | tee #{part}.po `
                end

                if FileTest.size( "#{part}.po" ) == 0
                    File.delete( "#{part}.po" )
                end
            end
        end

        if (enable_kipiplugins == true)

            # kipiplugins from extragear-graphics

            for part in ['kipiplugins',
                         'kipiplugin_facebook',
                         'kipiplugin_flashexport',
                         'kipiplugin_flickr',
                         'kipiplugin_remotestorage',
                         'kipiplugin_googleservices',
                         'kipiplugin_piwigo',
                         'kipiplugin_printimages',
                         'kipiplugin_sendimages',
                         'kipiplugin_smug',
                         'kipiplugin_dropbox',
                         'kipiplugin_imageshack',
                         'kipiplugin_imgur',
                         'kipiplugin_kmlexport',
                         'kipiplugin_rajce',
                         'kipiplugin_vkontakte',
                         'kipiplugin_wikimedia',
                         'kipiplugin_yandexfotki'
                        ]

                if isWindows
                    `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/messages/extragear-graphics/#{part}.po > #{part}.po`
                else
                    `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/messages/extragear-graphics/#{part}.po 2> /dev/null | tee #{part}.po `
                end

                if FileTest.size( "#{part}.po" ) == 0
                    File.delete( "#{part}.po" )
                end
            end
        end

        if (enable_libkvkontakte == true)

            # libkvkontakte from extragear-libs.

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
        end

        Dir.chdir("..")
        topmakefile << "add_subdirectory( #{lang} )\n"

    end
end

topmakefile.close()
puts ("\n")
