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
require 'fileutils'
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

i18nlangs = []

if isWindows
    i18nlangs = `type .\\project\\release\\subdirs`
else
    i18nlangs = `cat project/release/subdirs`
end

##########################################################################################
# EXTRACT TRANSLATED DOCUMENTATION FILES

if !(File.exists?("doc-translated") && File.directory?("doc-translated"))
    Dir.mkdir( "doc-translated" )
end

Dir.chdir( "doc-translated" )

# -- digiKam extraction ------------------------------------------------------

print("digikam: ")

l3makefile = File.new( "CMakeLists.txt", File::CREAT | File::RDWR | File::TRUNC )

i18nlangs.each_line do |lang|
    lang.chomp!()

    if (lang != nil && lang != "")

        print("#{lang}")

        if !(File.exists?(lang) && File.directory?(lang))
            Dir.mkdir(lang)
        end

        Dir.chdir(lang)
        Dir.mkdir("digikam")

        # This boolean variable is true if full documentation translation files can be fetch from repository.
        complete = true

        for part in
            [
            'annexes-credits',
            'editor-color',
            'editor-color-auto',
            'editor-color-bw',
            'editor-color-correction',
            'editor-color-curves',
            'editor-color-exposure',
            'editor-color-levels',
            'editor-color-mixer',
            'editor-color-wb',
            'editor-cm',
            'editor-cm-connection.docbook',
            'editor-cm-intro.docbook',
            'editor-cm-pcs.docbook',
            'editor-cm-rendering.docbook',
            'editor-cm-wkspace.docbook',
            'editor-cm-definitions.docbook',
            'editor-cm-monitor.docbook',
            'editor-cm-rawfile.docbook',
            'editor-cm-srgb.docbook',
            'editor-decorate',
            'editor-decorate-border',
            'editor-decorate-inserttext',
            'editor-decorate-texture',
            'editor-enhance',
            'editor-enhance-distortion.docbook',
            'editor-enhance-hotpixels.docbook',
            'editor-enhance-blur.docbook',
            'editor-enhance-nr.docbook',
            'editor-enhance-lenscorrection.docbook',
            'editor-enhance-restoration.docbook',
            'editor-enhance-vignetting.docbook',
            'editor-enhance-inpaint.docbook',
            'editor-enhance-redeyes.docbook',
            'editor-enhance-sharpen.docbook',
            'editor-filters',
            'editor-filters-blurfx',
            'editor-filters-colorsfx',
            'editor-filters-emboss',
            'editor-filters-oilpaint',
            'editor-filters-charcoal',
            'editor-filters-distortionfx',
            'editor-filters-filmgrain',
            'editor-filters-raindrops',
            'editor-photoediting',
            'editor-transform',
            'editor-transform-crop',
            'editor-transform-freerotation',
            'editor-transform-resize',
            'editor-transform-liquid',
            'editor-transform-shear',
            'editor-transform-perspective',
            'editor-transform-rotateflip',
            'editor-using',
            'index',
            'intro-background',
            'intro-camerasupport',
            'intro-database',
            'intro-imageformats',
            'intro-movieformats',
            'intro-firstrun',
            'intro-pluginsupport',
            'menu-bqm',
            'menu-camera',
            'menu-editor',
            'menu-lighttable',
            'menu-mainwindow',
            'tool-acquireimages',
            'tool-advrename',
            'tool-calendar',
            'tool-dropbox',
            'tool-expoblending',
            'tool-facebook',
            'tool-findduplicates',
            'tool-flashexport',
            'tool-flickrexport',
            'tool-geolocationeditor',
            'tool-googleexport',
            'tool-imageshack',
            'tool-imgur',
            'tool-kmlexport',
            'tool-maintenance',
            'tool-mediawiki',
            'tool-metadataeditor',
            'tool-panorama',
            'tool-piwigoexport',
            'tool-presentation',
            'tool-printwizard',
            'tool-rajce',
            'tool-remotestorage',
            'tool-sendimages',
            'tool-smug',
            'tool-vkontakte',
            'tool-yandexfotki',
            'using-bqm',
            'using-camera',
            'using-camera-basis',
            'using-camera-gps',
            'using-camera-intro',
            'using-camera-processing',
            'using-dam',
            'using-dam-build.docbook',
            'using-dam-copyright.docbook',
            'using-dam-corruption.docbook',
            'using-dam-intro.docbook',
            'using-dam-workflow.docbook',
            'using-lighttable',
            'using-mainwindow',
            'using-setup',
            'using-setup-album',
            'using-setup-database',
            'using-setup-metadata',
            'using-setup-metadata-intro',
            'using-setup-metadata-rotation-ac',
            'using-setup-metadata-views',
            'using-setup-quality',
            'using-setup-templates',
            'using-setup-camera',
            'using-setup-editor-iface',
            'using-setup-editor-save',
            'using-setup-editor-version',
            'using-setup-editor-raw',
            'using-setup-mimetype',
            'using-setup-theme',
            'using-setup-cm',
            'using-setup-intro',
            'using-setup-misc',
            'using-setup-misc-behavior',
            'using-setup-tooltip',
            'using-setup-collections',
            'using-setup-lighttable',
            'using-setup-plugins',
            'using-setup-slideshow',
            'using-sidebar',
            'using-sidebar-intro',
            'using-sidebar-properties',
            'using-sidebar-metadata',
            'using-sidebar-colors',
            'using-sidebar-captions',
            'using-sidebar-maps',
            'using-sidebar-filters',
            'using-sidebar-tools',
            'using-tagsmngr'
            ]

            if isWindows
                `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/docs/extragear-graphics/digikam/#{part}.docbook > digikam/#{part}.docbook`
            else
                `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/docs/extragear-graphics/digikam/#{part}.docbook 2> /dev/null | tee digikam/#{part}.docbook`
            end

            if File.exists?("digikam/#{part}.docbook") and FileTest.size( "digikam/#{part}.docbook" ) == 0
                File.delete( "digikam/#{part}.docbook" )
                complete = false
                break
            end

        end

        if (complete == true)
            makefile = File.new( "CMakeLists.txt", File::CREAT | File::RDWR | File::TRUNC )
            makefile << "KDOCTOOLS_CREATE_HANDBOOK( digikam/index.docbook INSTALL_DESTINATION ${HTML_INSTALL_DIR}/#{lang}/ SUBDIR digikam )"
            makefile.close()
        end

        Dir.chdir("..")

        if (complete == true)
            # complete checkout
            l3makefile << "add_subdirectory( #{lang} )\n"
            print(" ")
        else
            # uncomplete checkout
            FileUtils.rm_r(lang)
            print("(u) ")
        end

     end
end

puts ("\n")

# -- Showfoto extraction ------------------------------------------------------

print("showfoto: ")

i18nlangs.each_line do |lang|
    lang.chomp!()

    if (lang != nil && lang != "")

        if (File.exists?(lang))

            print("#{lang}")

            Dir.chdir(lang)
            Dir.mkdir("showfoto")

            # This boolean variable is true if full documentation translation files can be fetch from repository.
            complete = true

            for part in ['index']

                if isWindows
                    `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/docs/extragear-graphics/showfoto/#{part}.docbook > showfoto/#{part}.docbook`
                else
                    `svn cat svn://anonsvn.kde.org/home/kde/#{branch}/l10n-kf5/#{lang}/docs/extragear-graphics/showfoto/#{part}.docbook 2> /dev/null | tee showfoto/#{part}.docbook`
                end

                if File.exists?("showfoto/#{part}.docbook") and FileTest.size( "showfoto/#{part}.docbook" ) == 0
                    File.delete( "showfoto/#{part}.docbook" )
                    complete = false
                    break
                end

            end

            if (complete == true)
                makefile = File.open( "CMakeLists.txt", "a")
                makefile << "\nKDOCTOOLS_CREATE_HANDBOOK( showfoto/index.docbook INSTALL_DESTINATION ${HTML_INSTALL_DIR}/#{lang}/ SUBDIR digikam )"
                makefile.close()
            end

            if (complete == true)
                # complete checkout
                print(" ")
            else
                # uncomplete checkout
                print("(u) ")
            end

            Dir.chdir("..")

        end

     end
end

Dir.chdir("..")
puts ("\n")
